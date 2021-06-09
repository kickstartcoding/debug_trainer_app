module Stages.Finished.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (monospace)
import Html.Attributes as HtmlAttrs
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
        [ row [ width fill, spacing 20 ]
            [ Buttons.button [ width fill, Background.color Colors.green ]
                { name = "Reset the file and play again!"
                , msg = ResetFileAndPlayAgain
                }
            , Buttons.button [ width fill, Background.color Colors.red ]
                { name = "Reset the file and exit"
                , msg = ResetFileAndExit
                }
            ]
        , column
            [ width fill
            , height fill
            , scrollbarY
            ]
            [ paragraph [ Font.center, Font.size 30 ]
                (case finishType of
                    SuccessfullySolved ->
                        [ text "Nice work! To review, here's what we did to "
                        , Text.codeWithAttrs [ Border.rounded 5 ] (FilePath.nameOnly brokenFile.path)
                        , text ":"
                        ]

                    AskedToSeeAnswer ->
                        [ text "Here's what we did to "
                        , Text.codeWithAttrs [ Border.rounded 5 ] (FilePath.nameOnly brokenFile.path)
                        , text ":"
                        ]
                )
            , fileChanges brokenFile
            ]
        , if List.length brokenFile.changes > 1 then
            row [ width fill, spacing 20, paddingEach { bottom = 5, top = 0, left = 0, right = 0 } ]
                [ Buttons.button [ width fill, Background.color Colors.green ]
                    { name = "Reset the file and play again!"
                    , msg = ResetFileAndPlayAgain
                    }
                , Buttons.button [ width fill, Background.color Colors.red ]
                    { name = "Reset the file and exit"
                    , msg = ResetFileAndExit
                    }
                ]

          else
            none
        ]


fileChanges : BrokenFile -> Element msg
fileChanges brokenFile =
    column
        [ spacing 50
        , height (px 500)
        , paddingXY 40 40
        , centerX
        ]
    <|
        (brokenFile.changes
            |> List.map Tuple.first
            |> List.indexedMap (renderChange brokenFile)
        )


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
            , paddingXY 8 8
            , width fill
            ]
            ((changeDescription
                |> Utils.String.toFormattedElements
             )
                ++ [ text
                        (" on line "
                            ++ String.fromInt lineNumber
                        )
                   ]
            )
        , column [ spacing 20, width fill ]
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
    column [ width fill, spacing 10 ]
        [ paragraph [ Font.center ] [ text label ]
        , column
            [ Background.color Colors.veryLightGray
            , Border.rounded 5
            , width fill
            ]
            (getNearbyLines focusedLine content
                |> List.map (renderCodeLine focusedLine)
            )
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
    row [ width fill ]
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
    wholeFile
        |> String.lines
        |> List.indexedMap (\index line -> ( index + 1, line ))
        |> List.drop (lineNumber - 3)
        |> List.take 5
