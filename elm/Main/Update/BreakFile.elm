module Main.Update.BreakFile exposing (run)

-- import Commands.Break.Actions exposing (Action(..))
-- import Model exposing (Command(..))

import Breakers.Utils
import Main.Model exposing (ChangeData)
import Parsers.Generic.Parser as GenericParser
import Parsers.Generic.Segment exposing (Segment)
import Parsers.Generic.SegmentList as SegmentList
import Utils.List
import Utils.Tuple as Tuple
import Utils.Types.BreakType as BreakType exposing (BreakType(..))
import Utils.Types.FilePath exposing (FilePath)
import Utils.Types.FileType as FileType


run :
    { breakCount : Int
    , filepath : FilePath
    , fileContent : String
    , randomNumbers : List Int
    }
    -> Maybe BreakResult
run ({ filepath, fileContent } as config) =
    let
        fileType =
            FileType.fromFilePath filepath
    in
    GenericParser.run fileType fileContent
        -- |> Result.map (Debug.log "segments")
        -- |> Result.mapError (Debug.log "error")
        |> Result.map (randomlySelectFileChangesFromParsedSegments config)
        |> Result.toMaybe


type alias BreakResult =
    { newFileContent : String
    , changes : List ChangeData
    }


randomlySelectFileChangesFromParsedSegments :
    { breakCount : Int
    , filepath : FilePath
    , fileContent : String
    , randomNumbers : List Int
    }
    -> List Segment
    -> BreakResult
randomlySelectFileChangesFromParsedSegments config segments =
    selectFileChangesHelper config segments []
        |> Tuple.mapFirst Breakers.Utils.segmentsToContent
        |> Tuple.map2 BreakResult


selectFileChangesHelper :
    { breakCount : Int
    , filepath : FilePath
    , fileContent : String
    , randomNumbers : List Int
    }
    -> List Segment
    -> List ChangeData
    -> ( List Segment, List ChangeData )
selectFileChangesHelper config segments changes =
    let
        ( breakTypeChoiceSeed, segmentChoiceSeed ) =
            getSeeds config.breakCount config.randomNumbers

        maybeBreakType =
            chooseBreakType segments breakTypeChoiceSeed

        breakRunnerData =
            { randomNumber = segmentChoiceSeed
            , originalFileContent = config.fileContent
            , segments = segments
            , fileType = FileType.fromFilePath config.filepath
            }

        maybeChange =
            SegmentList.makeAChange maybeBreakType breakRunnerData
    in
    case maybeChange of
        Just ( newSegments, change ) ->
            if config.breakCount == 1 then
                ( newSegments, change :: changes )

            else
                selectFileChangesHelper { config | breakCount = config.breakCount - 1 }
                    newSegments
                    (change :: changes)

        Nothing ->
            ( segments, changes )


getSeeds : Int -> List Int -> ( Int, Int )
getSeeds breakCount randomNumberList =
    case List.drop (breakCount * 2) randomNumberList of
        num1 :: num2 :: _ ->
            ( num1, num2 )

        _ ->
            ( 0, 0 )


chooseBreakType : List Segment -> Int -> Maybe BreakType
chooseBreakType segments breakTypeInt =
    let
        viableBreakTypePossibilities =
            BreakType.allBreakTypes
                |> List.map
                    (\breakType ->
                        ( breakType, SegmentList.countForBreakType breakType segments )
                    )
                |> List.filter (\( _, count ) -> count > 0)

        totalCandidateCount =
            List.foldl (Tuple.second >> (+)) 0 viableBreakTypePossibilities

        totalViableBreakTypes =
            List.length viableBreakTypePossibilities

        breakTypeProbabilities =
            viableBreakTypePossibilities
                |> List.map
                    (\( breakType, count ) ->
                        ( breakType
                        , determineChoiceProbability
                            { breakTypeCount = totalViableBreakTypes
                            , breakOpportunityCount = count
                            , totalBreakOpportunities = totalCandidateCount
                            }
                        )
                    )
    in
    breakTypeProbabilities
        |> List.concatMap
            (\( breakType, breakPercent ) ->
                List.repeat breakPercent breakType
            )
        |> Utils.List.pickRandom breakTypeInt


{-| determineChoiceProbability

    Averages the percentage of break types with the percentage of
    opportunities in the file to make an incident of each break type

-}
determineChoiceProbability : { breakTypeCount : Int, breakOpportunityCount : Int, totalBreakOpportunities : Int } -> Int
determineChoiceProbability { breakTypeCount, breakOpportunityCount, totalBreakOpportunities } =
    ((toFloat breakOpportunityCount / toFloat totalBreakOpportunities)
        + (1.0 / toFloat breakTypeCount)
    )
        / 2.0
        |> (*) 100
        |> round
