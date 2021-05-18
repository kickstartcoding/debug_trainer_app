module Breakers.RemoveParenthesis exposing (run, validCandidateData)

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
                    whereInTheLineIsTheBracket =
                        if String.startsWith "\n" content then
                            StartOfLine

                        else
                            EndOfLine

                    lineNumber =
                        originalFileContent
                            |> FileContent.rowFromOffset
                                (case whereInTheLineIsTheBracket of
                                    StartOfLine ->
                                        offset + 1

                                    EndOfLine ->
                                        offset
                                )

                    withoutBracket =
                        String.filter (not << isParenOrBracket) content

                    newSegments =
                        ListEx.setAt index (Segment offset withoutBracket (ReturnStatement BreakHasBeenApplied)) segments
                in
                ( newSegments
                , { lineNumber = lineNumber
                  , changeDescription =
                        "removed a `"
                            ++ String.trim content
                            ++ "` from the "
                            ++ (case whereInTheLineIsTheBracket of
                                    StartOfLine ->
                                        "beginning of the line"

                                    EndOfLine ->
                                        "end of the line"
                               )
                  , breakType = RemoveParenthesis
                  }
                )
            )


type WhereInLine
    = StartOfLine
    | EndOfLine


isParenOrBracket : Char -> Bool
isParenOrBracket char =
    List.member char [ '{', '}', '(', ')', '[', ']' ]


validCandidateData : Segment -> Maybe Segment
validCandidateData ({ segmentType } as segment) =
    if segmentType == ParenthesisOrBracket BreakNotAppliedYet then
        Just segment

    else
        Nothing
