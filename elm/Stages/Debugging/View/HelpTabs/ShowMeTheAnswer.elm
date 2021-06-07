module Stages.Debugging.View.HelpTabs.ShowMeTheAnswer exposing (..)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (monospace)
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.Types.BrokenFile as BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FilePath as FilePath
import Utils.Types.FileType as FileType exposing (FileType)
import Utils.UI.Buttons as Buttons
import Utils.UI.Css as Css
import Utils.UI.Text as Text


render : Bool -> BrokenFile -> Element Msg
render answerIsShowing ({ originalContent, updatedContent, path } as brokenFile) =
    if answerIsShowing then
        column
            [ spacing 50
            , height fill
            , width fill
            , paddingXY 40 40
            , scrollbars
            ]
        <|
            (brokenFile.changes
                |> List.map Tuple.first
                |> List.indexedMap (renderChange brokenFile)
            )
        -- [ renderFile (FilePath.toString path ++ " (original file)") originalContent
        -- , renderFile
        --     (FilePath.toString path
        --         ++ " (file with "
        --         ++ BrokenFile.bugOrBugsString brokenFile
        --         ++ " added)"
        --     )
        --     updatedContent
        -- ]

    else
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ paragraph
                [ width (px 400)
                , Font.center
                ]
                [ text
                    ("Can't figure out the "
                        ++ BrokenFile.bugOrBugsString brokenFile
                        ++ "? No problem, click the button below to show exactly what "
                        ++ Constants.appName
                        ++ " did to the file."
                    )
                ]
            , Buttons.button
                [ centerX ]
                { msg = ShowTheAnswer
                , name = "Show me the answer"
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
            , paddingXY 8 8
            , width fill
            ]
            [ text
                (changeDescription
                    ++ " on line "
                    ++ String.fromInt lineNumber
                )
            ]
        , row [ spacing 20, width fill ]
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
        , Text.codeWithAttrs
            [ Background.color lineBackground
            , paddingEach { top = 0, bottom = 0, right = 0, left = 10 }
            , Border.rounded 0
            , fontStyle
            , width fill
            ]
            content
        ]


getNearbyLines : Int -> String -> List ( Int, String )
getNearbyLines lineNumber wholeFile =
    wholeFile
        |> String.lines
        |> List.indexedMap (\index line -> ( index + 1, line ))
        |> List.drop (lineNumber - 3)
        |> List.take 5
