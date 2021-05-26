module Stages.Debugging.View.HelpTabs.DebuggingTips exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.List
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FileType as FileType exposing (FileType)
import Utils.UI.Link as Link


render : { currentDebuggingTip : Int, brokenFile : BrokenFile } -> Element Msg
render { currentDebuggingTip, brokenFile } =
    let
        fileType =
            brokenFile.path |> FileType.fromFilePath
    in
    column [ width fill, height fill, spacing 30 ]
        [ el
            [ height fill
            , width fill
            , paddingXY 60 20
            ]
            (column [ centerY, spacing 10 ]
                (Utils.List.getByWrappedIndex currentDebuggingTip (debuggingTips fileType)
                    |> Maybe.withDefault defaultTip
                )
            )
        , row [ centerX, spacing 20 ]
            [ Input.button
                [ Background.color Colors.purple
                , Font.color Colors.white
                , Font.center
                , centerX
                , paddingXY 35 20
                , Border.rounded 5
                , width (px 200)
                ]
                { onPress = Just SwitchToPreviousDebuggingTip
                , label = text "previous tip"
                }
            , Input.button
                [ Background.color Colors.purple
                , Font.color Colors.white
                , Font.center
                , centerX
                , paddingXY 35 20
                , Border.rounded 5
                , width (px 200)
                ]
                { onPress = Just SwitchToNextDebuggingTip
                , label = text "next tip"
                }
            ]
        ]


defaultTip =
    tip
        { header = "Tip #1: Find the line number"
        , content = [ paragraph [] [ text "Find the line number in the error message and check that part of the file first." ] ]
        }


debuggingTips fileType =
    [ defaultTip
    , tip
        { header = "Tip #2: Check the error message"
        , content =
            [ paragraph []
                [ text "If your code is printing out an error message, read what the message says is wrong and keep it in mind when trying to figure out the bug."
                ]
            , paragraph []
                [ text "If you're not sure what a particular error message means, try copying and pasting it into a search engine like "
                , Link.render
                    { url = "https://duckduckgo.com/"
                    , label = text "DuckDuckGo"
                    }
                , text " or "
                , Link.render
                    { url = "https://google.com/"
                    , label = text "Google"
                    }
                , text "."
                ]
            , paragraph []
                [ text "You can read some search tips that will work for most search engines "
                , Link.render
                    { url = "https://markodenic.com/use-google-like-a-pro/"
                    , label = text "here"
                    }
                , text "."
                ]
            ]
        }
    , tip
        { header = "Tip #3: Print your variables"
        , content =
            [ paragraph [] [ text "Print out the variables in your program — even if you think you know what they all are, some of them may surprise you!" ]
            , paragraph []
                [ text "In "
                , el [ Font.bold ] (text (FileType.toString fileType))
                , text " you can use "
                , el [ Font.bold ] (text (FileType.toPrintFunctionName fileType))
                , text " for this."
                ]
            ]
        }
    , tip
        { header = "Tip #4: Get hints from the \"Bug Hints\" tab"
        , content = [ paragraph [] [ text "If you're stuck, the \"Bug Hints\" tab can tell you what line of the file a bug is on, or what type of bug it is." ] ]
        }
    , tip
        { header = "Tip #5: Take breaks"
        , content =
            [ paragraph [] [ text "Sometimes you just need to get some food or some water, go to the bathroom, or go for a walk and let you brain rest a bit." ]
            , paragraph [] [ text "You might be surprised at the things you'll notice about your code after taking a break that you had completely missed before." ]
            ]
        }
    ]


tip { header, content } =
    [ tipHeader header
    , tipColumn content
    ]


tipHeader content =
    paragraph [ Font.size 20, Font.bold, paddingXY 12 0 ] [ text content ]


tipColumn content =
    column
        [ spacing 20
        , Background.color Colors.lightGray
        , Border.rounded 5
        , paddingXY 30 20
        , centerY
        , centerX
        ]
        content
