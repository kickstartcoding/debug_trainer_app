module Breakers.Utils exposing
    ( BreakData
    , BreakRunnerData
    , candidates
    , chooseCandidate
    , segmentsToContent
    )

import Parsers.Generic.Segment exposing (Segment, SegmentType(..))
import Utils.List
import Utils.Types.BreakType exposing (BreakType)
import Utils.Types.FileType exposing (FileType)


type alias BreakRunnerData =
    { randomNumber : Int
    , originalFileContent : String
    , segments : List Segment
    , fileType : FileType
    }


type alias BreakData =
    { updatedContent : String
    , lineNumber : Int
    , changeDescription : String
    , breakType : BreakType
    }


segmentsToContent : List Segment -> String
segmentsToContent segments =
    segments
        |> List.map .content
        |> List.foldr (++) ""


chooseCandidate : Int -> (Segment -> Maybe candidateData) -> List Segment -> Maybe ( Int, candidateData )
chooseCandidate randomNumber mapValidCandidate segments =
    segments
        |> candidates mapValidCandidate
        |> Utils.List.pickRandom randomNumber


candidates : (Segment -> Maybe candidateData) -> List Segment -> List ( Int, candidateData )
candidates mapValidCandidate segments =
    segments
        |> List.indexedMap Tuple.pair
        |> List.filterMap
            (\( index, segment ) ->
                mapValidCandidate segment
                    |> Maybe.map (\data -> ( index, data ))
            )
