module Stages.Debugging.View.IDontSeeAnyErrorsPage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Stages.Debugging.Model exposing (Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.FilePath as FilePath
import Utils.UI.Buttons as Buttons


render : BrokenFile -> Element Msg
render { path } =
    column [ spacing 50 ]
        [ Buttons.back { name = "back to instructions", msg = ChangePage StepsPage }
        , el [ paddingXY 35 0 ] <|
            column
                [ Border.rounded 5
                , paddingXY 40 30
                , Background.color Colors.veryLightGray
                , spacing 30
                ]
                [ paragraph []
                    [ text "If you have run "
                    , el [ Font.bold, Font.family [ Font.monospace ] ] (text (FilePath.nameOnly path))
                    , text " (or the project it's from) and aren't seeing any errors, there are a few things that might be happening."
                    ]
                , paragraph []
                    [ el [ Font.bold ] (text "1. It may be that the code that the bug was added to isn't running when you run the file (or project)")
                    , text ". For example, if the file is part of a web site, you may need to visit a specific page or press a specific button to trigger the error."
                    ]
                , paragraph [ paddingXY 40 0 ] [ text "If you think this might be it, try running the file (or project) in different ways and see if any of them produce an error." ]
                , paragraph []
                    [ el [ Font.bold ] (text "2. It may be that the code that the bug was added to just never gets run.")
                    , text " Maybe it's in a function that doesn't get used or an option that never gets selected? This app can't check for that sort of thing on its own, unfortunately."
                    ]
                , paragraph [ paddingXY 40 0 ]
                    [ text
                        ("If you think this might be it, then you should probably reset the file, remove the unused code, and then try making "
                            ++ Constants.appName
                            ++ " generate a different error."
                        )
                    ]
                , paragraph []
                    [ el [ Font.bold ] (text "3. It may be that the change we introduced into the file doesn't actually change the code enough to cause errors.")
                    ]
                , paragraph [ paddingXY 40 0 ] [ text "If you think this might be it, try rerunning Debugging Practice to introduce a different error." ]
                , Buttons.button [ width (px 400), centerX ]
                    { name = "reset broken file and play again"
                    , msg = ResetFileAndPlayAgain
                    }
                ]
        , el [ width fill, height (px 20) ] none
        ]
