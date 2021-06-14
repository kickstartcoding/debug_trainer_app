module Stages.Debugging.View.StepsPage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Stages.Debugging.Model exposing (Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.FilePath as FilePath
import Utils.UI.Buttons as Buttons


render : Int -> BrokenFile -> Element Msg
render bugCount { changes, path } =
    let
        changeCount =
            List.length changes
    in
    column
        [ Font.color (rgb 0 0 0)
        , Font.size 25
        , Font.center
        , spacing 50
        , centerX
        , centerY
        , paddingXY 0 20
        ]
        [ paragraph []
            [ text
                ("I put "
                    ++ (changeCount
                            |> String.fromInt
                       )
                    ++ " "
                    ++ Pluralize.singularOrPlural changeCount "bug"
                    ++ " in "
                )
            , el
                [ Background.color (Colors.darkened 0.1)
                , paddingXY 10 5
                , Font.bold
                , Font.family [ Font.typeface "Courier" ]
                , rounded 5
                ]
                (text (FilePath.nameOnly path))
            , text
                ("! Can you figure out where "
                    ++ Pluralize.itIsOrTheyAre changeCount
                    ++ "?"
                )
            ]
        , column
            [ centerX
            , Font.alignLeft
            , spacing 20
            , width (px 350)
            , Background.color (Colors.darkened 0.1)
            , paddingXY 40 20
            , rounded 5
            ]
            [ paragraph [] [ el [ Font.bold ] (text "step 1: "), text "run the file (or the project it's from)" ]
            , paragraph [] [ el [ Font.bold ] (text "step 2: "), text ("read the " ++ Pluralize.singularOrPlural changeCount "error") ]
            , paragraph []
                [ el [ Font.bold ] (text "step 3: ")
                , text "open the file in your favorite text editor and get debugging!"
                ]
            ]
        , column [ spacing 20, centerX ]
            [ row [ spacing 20, centerX ]
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
