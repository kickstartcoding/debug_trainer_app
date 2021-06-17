module Stages.Debugging.View.HelpTabs.DebuggingTips exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.List
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.FileType as FileType exposing (FileType)
import Utils.UI.Buttons as Buttons
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
            , paddingXY 60 0
            ]
            (column [ centerY, centerX, spacing 10 ]
                (Utils.List.getByWrappedIndex currentDebuggingTip (debuggingTips fileType)
                    |> Maybe.withDefault defaultTip
                )
            )
        , row [ centerX, spacing 20 ]
            [ Buttons.button []
                { msg = SwitchToPreviousDebuggingTip
                , name = "previous tip"
                }
            , Buttons.button []
                { msg = SwitchToNextDebuggingTip
                , name = "next tip"
                }
            ]
        ]


defaultTip : List (Element msg)
defaultTip =
    tip []
        { header = "Tip #1: Find the line number"
        , content = [ paragraph [] [ text "Find the line number in the error message and check that part of the file first." ] ]
        }


debuggingTips : FileType -> List (List (Element msg))
debuggingTips fileType =
    [ defaultTip
    , tip [ Font.size 18 ]
        { header = "Tip #2: Check the error message"
        , content =
            [ paragraph []
                [ text "If your code is printing out an error message, read what the message says is wrong and keep it in mind when trying to figure out the bug."
                ]
            , paragraph []
                [ text "If you're not sure what a particular error message means, try copying and pasting it into a search engine like "
                , Link.render []
                    { url = "https://duckduckgo.com/"
                    , label = text "DuckDuckGo"
                    }
                , text " or "
                , Link.render []
                    { url = "https://google.com/"
                    , label = text "Google"
                    }
                , text "."
                ]
            , paragraph []
                [ text "You can read some search tips that will work for most search engines "
                , Link.render []
                    { url = "https://markodenic.com/use-google-like-a-pro/"
                    , label = text "here"
                    }
                , text "."
                ]
            ]
        }
    , tip []
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
    , tip [ Font.size 18 ]
        { header = "Tip #4: Read through your code one line at a time"
        , content =
            [ paragraph [] [ text "Read through your code one line at a time. For each line, check if you know the value of every variable on that line, the return value of every function, the outcome of every comparison, et cetera." ]
            , paragraph [] [ text "Don't think about anything that happens on the next line until you've figured out everything that happens on the one you're looking at." ]
            , paragraph [] [ text "If you're even the slightest bit unsure about something, print it to make sure." ]
            ]
        }
    , tip []
        { header = "Tip #5: Get hints from the \"Bug Hints\" tab"
        , content = [ paragraph [] [ text "If you're stuck, the \"Bug Hints\" tab can tell you what line of the file a bug is on, or what type of bug it is." ] ]
        }
    , tip []
        { header = "Tip #6: Take breaks"
        , content =
            [ paragraph [] [ text "Sometimes you just need to get some food or some water, go to the bathroom, or go for a walk and let you brain rest a bit." ]
            , paragraph [] [ text "You might be surprised at the things you'll notice about your code after taking a break." ]
            ]
        }
    , tip []
        { header = "Tip #7: Ask for help"
        , content =
            [ paragraph [] [ text "One of the best ways to learn and figure things out is to get help from friends and community." ]
            , paragraph [] [ text "Finding people and communities who can answer questions you have and offer encouragement when stuff is hard is so, so important." ]
            , paragraph [] [ text "Don't believe the individualism hype: it is both hard and pointless to force yourself to do this all on your own." ]
            ]
        }
    ]


tip : List (Attribute msg) -> { header : String, content : List (Element msg) } -> List (Element msg)
tip attrs { header, content } =
    [ tipHeader header
    , tipColumn attrs content
    ]


tipHeader : String -> Element msg
tipHeader content =
    paragraph [ Font.size 20, Font.bold, paddingXY 12 0 ] [ text content ]


tipColumn : List (Attribute msg) -> List (Element msg) -> Element msg
tipColumn attrs content =
    column
        ([ spacing 20
         , Background.color Colors.lightGray
         , Border.rounded 5
         , paddingXY 30 20
         , centerY
         , centerX
         ]
            ++ attrs
        )
        content
