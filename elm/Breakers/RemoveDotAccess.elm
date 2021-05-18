module Breakers.RemoveDotAccess exposing (run, validCandidateData)

import Breakers.Utils exposing (BreakRunnerData)
import List.Extra as ListEx
import Parsers.Generic.Segment exposing (BreakStatus(..), Segment, SegmentType(..))
import Utils.FileContent as FileContent
import Utils.List
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.ChangeData exposing (ChangeData)


run : BreakRunnerData -> Maybe ( List Segment, ChangeData )
run { randomNumber, originalFileContent, segments } =
    segments
        |> Breakers.Utils.chooseCandidate randomNumber validCandidateData
        |> Maybe.map
            (\( index, { content, offset } ) ->
                let
                    dotSections =
                        content
                            |> String.split "."

                    indexToRemove =
                        dotSections
                            |> List.indexedMap Tuple.pair
                            |> Utils.List.pickRandom (randomNumber // 1000)
                            |> Maybe.map Tuple.first
                            |> Maybe.withDefault 0

                    newDotAccess =
                        dotSections
                            |> ListEx.removeAt indexToRemove
                            |> String.join "."

                    lineNumber =
                        FileContent.rowFromOffset offset originalFileContent

                    newSegments =
                        ListEx.setAt index (Segment offset newDotAccess (DotAccess BreakHasBeenApplied)) segments
                in
                ( newSegments
                , { lineNumber = lineNumber
                  , changeDescription = "changed `" ++ content ++ "` to `" ++ newDotAccess ++ "`"
                  , breakType = RemoveDotAccess
                  }
                )
            )


validCandidateData : Segment -> Maybe Segment
validCandidateData ({ segmentType } as segment) =
    if segmentType == DotAccess BreakNotAppliedYet then
        Just segment

    else
        Nothing
