module Stages.Intro.View exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (monospace)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.UI.Buttons as Buttons


render : Element Msg
render =
    column
        [ height fill
        , width fill
        ]
        [ column [ Font.center, spacing 10, centerX, height fill ]
            [ paragraph [ centerX, Font.size 30 ] [ text ("Welcome to " ++ Constants.appName ++ "!") ]
            , paragraph [ Font.size 22, centerX ]
                [ text "created by teachers at "
                , newTabLink
                    [ Font.color Colors.kickstartCodingBlue ]
                    { url = "https://kickstartcoding.com", label = text "Kickstart Coding" }
                ]
            ]
        , column
            [ spacing 30
            , width (px 600)
            , height fill
            , centerX
            ]
            [ column [ spacing 20, centerY, height fill ]
                [ column [ centerX, spacing 20 ]
                    [ paragraph [] [ el [ Font.bold ] (text "step 1: "), text (Constants.appName ++ " will introduce a bug into a file of your choice") ]
                    , paragraph [] [ el [ Font.bold ] (text "step 2: "), text "you try to figure out the bug with the help of hints and advice from the app" ]
                    , paragraph [] [ el [ Font.bold ] (text "step 3: "), text "the app will return your file to its original working version when you're done" ]
                    ]
                , Buttons.button [ centerX ]
                    { name = "let's get started!"
                    , msg = LetsGetStarted
                    }
                ]
            ]
        , howDoesThisAppWorkLink
        ]


howDoesThisAppWorkLink : Element msg
howDoesThisAppWorkLink =
    el [ width fill, height fill ]
        (paragraph [ alignRight, alignBottom, Font.alignRight ]
            [ newTabLink
                [ Font.color Colors.kickstartCodingBlue
                , Font.size 18
                ]
                { url = "https://github.com/kickstartcoding/debug_trainer_app/issues"
                , label = text "Issues Suggestions? Click here."
                }
            ]
        )
