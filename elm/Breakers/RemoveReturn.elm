module Breakers.RemoveReturn exposing (run, validCandidateData)

import Breakers.Utils exposing (BreakRunnerData)
import List.Extra as ListEx
import Main.Model exposing (ChangeData)
import Parsers.Generic.Segment exposing (BreakStatus(..), Segment, SegmentType(..))
import Utils.FileContent as FileContent
import Utils.Types.BreakType exposing (BreakType(..))


run : BreakRunnerData -> Maybe ( List Segment, ChangeData )
run { randomNumber, originalFileContent, segments } =
    segments
        |> Breakers.Utils.chooseCandidate randomNumber validCandidateData
        |> Maybe.map
            (\( index, { content, offset } ) ->
                let
                    lineNumber =
                        FileContent.rowFromOffset
                            (offset + String.length content - 1)
                            originalFileContent

                    newSegments =
                        ListEx.setAt index (Segment offset (String.dropRight 7 content) (ReturnStatement BreakHasBeenApplied)) segments
                in
                ( newSegments
                , { lineNumber = lineNumber
                  , changeDescription = "removed a `return`"
                  , breakType = RemoveReturn
                  }
                )
            )


validCandidateData : Segment -> Maybe Segment
validCandidateData ({ segmentType } as segment) =
    if segmentType == ReturnStatement BreakNotAppliedYet then
        Just segment

    else
        Nothing
