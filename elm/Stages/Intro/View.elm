module Stages.Intro.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.UI.Buttons as Buttons
import Utils.UI.Link as Link


render : String -> Element Msg
render logoPath =
    column
        [ height fill
        , width fill
        , spacing 50
        ]
        [ column [ Font.center, spacing 10, centerX, height fill ]
            [ paragraph [ centerX, Font.size 30 ] [ text ("Welcome to " ++ Constants.appName ++ "!") ]
            , row [ Font.size 22, centerX ]
                [ text "created by teachers at "
                , kickstartLink logoPath
                ]
            ]
        , column
            [ centerX
            , centerY
            , Font.alignLeft
            , spacing 20
            , width (px 500)
            , Background.color (Colors.darkened 0.1)
            , paddingXY 40 20
            , Border.rounded 5
            ]
            [ paragraph []
                [ el [ Font.bold ] (text "step 1: ")
                , text (Constants.appName ++ " will introduce a bug into a file of your choice")
                ]
            , paragraph []
                [ el [ Font.bold ] (text "step 2: ")
                , text ("you try to figure out the bug with the help of hints and advice from " ++ Constants.appName)
                ]
            , paragraph []
                [ el [ Font.bold ] (text "step 3: ")
                , text (Constants.appName ++ " will return your file to its original working version when you're done")
                ]
            ]
        , Buttons.button [ centerX ]
            { name = "let's get started!"
            , msg = LetsGetStarted
            }
        , howDoesThisAppWorkLink
        ]


kickstartLink : String -> Element msg
kickstartLink logoPath =
    Link.render
        [ Font.color Colors.kickstartCodingBlue ]
        { url = "https://kickstartcoding.com"
        , label =
            row []
                [ image
                    [ height (px 40)
                    , moveRight 3
                    , moveUp 1
                    ]
                    { src = logoPath, description = "The Kickstart Coding logo — a partially pixelated blue hummingbird" }
                , text "Kickstart Coding"
                ]
        }


howDoesThisAppWorkLink : Element msg
howDoesThisAppWorkLink =
    el [ width fill, height fill ]
        (paragraph [ alignRight, alignBottom, Font.alignRight ]
            [ Link.render [ Font.size 18 ]
                { url = "https://github.com/kickstartcoding/debug_trainer_app/issues"
                , label = text "Issues? Suggestions? Click here."
                }
            ]
        )
