module Stages.Debugging.View.StepsPage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Stages.Debugging.Model exposing (Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.String
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.FilePath as FilePath
import Utils.UI.Buttons as Buttons
import Utils.UI.Text as Text


render : Int -> BrokenFile -> Element Msg
render requestedBugCount { changes, path } =
    let
        changeCount =
            List.length changes

        couldNotFindEnoughPossibleBugs =
            changeCount < requestedBugCount
    in
    column
        [ Font.color (rgb 0 0 0)
        , Font.size 25
        , Font.center
        , spacing 20
        , spaceEvenly
        , centerX
        , centerY
        , paddingEach { top = 20, bottom = 5, left = 0, right = 0 }
        , height fill
        ]
        [ paragraph []
            (Utils.String.formatBackticks (Text.codeWithAttrs [ Font.extraBold, Border.rounded 5 ])
                ("I put "
                    ++ (changeCount
                            |> String.fromInt
                       )
                    ++ " "
                    ++ Pluralize.singularOrPlural changeCount "bug"
                    ++ " in `"
                    ++ FilePath.nameOnly path
                    ++ "`"
                    ++ (if couldNotFindEnoughPossibleBugs then
                            " (sorry I couldn't get to "
                                ++ String.fromInt requestedBugCount
                                ++ " "
                                ++ Pluralize.singularOrPlural requestedBugCount "bug"
                                ++ "; I couldn't find enough buggable things in the code 😢)"

                        else
                            ""
                       )
                    ++ "! Can you figure out where "
                    ++ Pluralize.itIsOrTheyAre changeCount
                    ++ "?"
                )
            )
        , column
            [ centerX
            , centerY
            , Font.alignLeft
            , spacing 20
            , width (px 350)
            , Background.color (Colors.darkened 0.1)
            , paddingXY 40 20
            , Border.rounded 5
            ]
            [ paragraph [] [ el [ Font.bold ] (text "step 1: "), text "run the file (or the project it's from)" ]
            , paragraph [] [ el [ Font.bold ] (text "step 2: "), text ("read the " ++ Pluralize.singularOrPlural changeCount "error") ]
            , paragraph []
                [ el [ Font.bold ] (text "step 3: ")
                , text "open the file in your favorite text editor and get debugging!"
                ]
            ]
        , column [ spacing 15, centerX ]
            [ row [ spacing 15, centerX ]
                [ Buttons.button [ Background.color Colors.purple ]
                    { msg = ChangePage HelpPage
                    , name = "help me!"
                    }
                , Buttons.button [ Background.color Colors.green ]
                    { msg = ISolvedIt
                    , name = "I solved it!"
                    }
                ]
            , Buttons.button [ Background.color Colors.red, centerX ]
                { msg = ChangePage IDontSeeAnyErrorsPage
                , name = "I don't see any errors!"
                }
            ]
        ]
