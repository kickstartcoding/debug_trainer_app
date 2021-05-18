module Breakers.CaseSwap exposing (run, validCandidateData)

import Breakers.Utils exposing (BreakRunnerData)
import List.Extra as ListEx
import Main.Model exposing (ChangeData)
import Parsers.Generic.Segment exposing (BreakStatus(..), Segment, SegmentType(..))
import Utils.FileContent as FileContent
import Utils.String as StrUtils
import Utils.Types.BreakType exposing (BreakType(..))


run : BreakRunnerData -> Maybe ( List Segment, ChangeData )
run { randomNumber, originalFileContent, segments } =
    segments
        |> Breakers.Utils.chooseCandidate randomNumber validCandidateData
        |> Maybe.map
            (\( index, { content, offset } ) ->
                let
                    newWord =
                        StrUtils.toggleTitleCase content

                    lineNumber =
                        FileContent.rowFromOffset offset originalFileContent

                    newSegments =
                        ListEx.setAt index (Segment offset newWord (Word BreakHasBeenApplied)) segments
                in
                ( newSegments
                , { lineNumber = lineNumber
                  , changeDescription = "changed `" ++ content ++ "` to `" ++ newWord ++ "`"
                  , breakType = CaseSwap
                  }
                )
            )


validCandidateData : Segment -> Maybe Segment
validCandidateData ({ content, segmentType } as segment) =
    if
        segmentType
            == Word BreakNotAppliedYet
            && StrUtils.isMoreThanOneCharacter content
            && not (StrUtils.isAllCaps content)
    then
        Just segment

    else
        Nothing
