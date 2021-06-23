module Stages.Finished.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Stages.Finished.Model exposing (FinishType(..), Model)
import Stages.Finished.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.String
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath as FilePath
import Utils.UI.Buttons as Buttons
import Utils.UI.Css as Css
import Utils.UI.Text as Text


render : Model -> Element Msg
render { finishType, brokenFile } =
    column
        [ width fill
        , height fill
        , spacing 30
        ]
        [ finishButtons [ paddingEach { bottom = 5, top = 0, left = 0, right = 0 } ]
        , column
            [ width fill
            , height fill
            ]
            [ paragraph [ Font.center, Font.size 30 ]
                (case finishType of
                    SuccessfullySolved ->
                        [ text ("Nice work! To review, here's what " ++ Constants.appName ++ " did to ")
                        , Text.codeWithAttrs [ Border.rounded 5 ] (FilePath.nameOnly brokenFile.path)
                        , text ":"
                        ]

                    AskedToSeeAnswer ->
                        [ text ("Here's what " ++ Constants.appName ++ " did to ")
                        , Text.codeWithAttrs [ Border.rounded 5 ] (FilePath.nameOnly brokenFile.path)
                        , text ":"
                        ]
                )
            , fileChanges brokenFile
            ]
        , if List.length brokenFile.changes > 1 then
            finishButtons [ paddingEach { bottom = 5, top = 0, left = 0, right = 0 } ]

          else
            none
        ]


fileChanges : BrokenFile -> Element msg
fileChanges brokenFile =
    column
        [ spacing 50
        , paddingXY 40 40
        , centerX
        ]
    <|
        (brokenFile.changes
            |> List.map Tuple.first
            |> List.indexedMap (renderChange brokenFile)
        )


finishButtons : List (Attribute Msg) -> Element Msg
finishButtons attrs =
    row ([ width fill, spacing 20 ] ++ attrs)
        [ Buttons.button [ width fill, Background.color Colors.green ]
            { name = "Reset the file and play again!"
            , msg = ResetFileAndPlayAgain
            }
        , Buttons.button [ width fill, Background.color Colors.red ]
            { name = "Reset the file and exit"
            , msg = ResetFileAndExit
            }
        ]


renderChange : BrokenFile -> Int -> ChangeData -> Element msg
renderChange brokenFile index { lineNumber, changeDescription } =
    column
        [ width fill
        , spacing 20
        ]
        [ paragraph
            [ Font.size 24
            , Font.center
            , Font.color Colors.white
            , Background.color Colors.purple
            , Border.rounded 5
            , paddingXY 20 8
            , width (maximum 740 fill)
            ]
            ((changeDescription
                |> Utils.String.formatBackticks
                    (Text.codeWithAttrs
                        [ paddingXY 6 1
                        , Border.rounded 3
                        , Background.color (Colors.lightened 0.8)
                        ]
                    )
             )
                ++ [ text
                        (" on line "
                            ++ String.fromInt lineNumber
                        )
                   ]
            )
        , column [ spacing 20, width fill, centerX ]
            [ labeledCodeSnippet
                { label = "in the original file"
                , focusedLine = lineNumber
                , content = brokenFile.originalContent
                }
            , labeledCodeSnippet
                { label = "after being broken"
                , focusedLine = lineNumber
                , content = brokenFile.updatedContent
                }
            ]
        ]


labeledCodeSnippet : { label : String, focusedLine : Int, content : String } -> Element msg
labeledCodeSnippet { label, focusedLine, content } =
    let
        codeLines =
            getNearbyLines focusedLine content
    in
    column [ spacing 10, centerX ]
        [ paragraph [ Font.center ] [ text label ]
        , column
            [ Background.color Colors.veryLightGray
            , Border.rounded 5
            , width (px 700)
            , height (px 136)
            , scrollbarX
            ]
            (List.map (renderCodeLine focusedLine) codeLines)
        ]


renderCodeLine : Int -> ( Int, String ) -> Element msg
renderCodeLine changedLineNumber ( lineNumber, content ) =
    let
        { numBackground, lineBackground, fontStyle } =
            if lineNumber == changedLineNumber then
                { numBackground = rgb 0.7 0.7 0.7
                , lineBackground = Colors.lightGray
                , fontStyle = Font.extraBold
                }

            else
                { numBackground = Colors.lightGray
                , lineBackground = Colors.veryLightGray
                , fontStyle = Font.medium
                }
    in
    row [ width fill, centerY ]
        [ Text.codeWithAttrs
            [ Css.unselectable
            , Background.color numBackground
            , fontStyle
            , Border.rounded 0
            ]
            (String.fromInt lineNumber)
        , paragraph
            [ Background.color lineBackground
            , paddingEach { top = 0, bottom = 0, right = 0, left = 10 }
            , width fill
            ]
            [ Text.codeWithAttrs
                [ Background.color Colors.transparent
                , Border.rounded 0
                , fontStyle
                , width fill
                ]
                (content |> String.replace " " "\u{00A0}")
            ]
        ]


getNearbyLines : Int -> String -> List ( Int, String )
getNearbyLines lineNumber wholeFile =
    let
        lines =
            wholeFile
                |> String.lines
                |> List.indexedMap (\index line -> ( index + 1, line ))

        lineCount =
            List.length lines

        linesAwayFromEndOfFile =
            lineCount - lineNumber
    in
    if lineNumber < 4 then
        -- if close the the start of the file, take the first 5 lines
        lines
            |> List.take 5

    else if linesAwayFromEndOfFile < 4 then
        -- if close the the end of the file, take the first 5 lines
        lines
            |> List.reverse
            |> List.take 5
            |> List.reverse

    else
        -- otherwise, take the previous and next two lines after the target line
        lines
            |> List.drop (lineNumber - 3)
            |> List.take 5
