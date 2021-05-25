module Main.View exposing (render)

import Element exposing (..)
import Html exposing (Html)
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Stages.Debugging.View
import Main.View.Start


render : Model -> { title : String, body : List (Html Msg) }
render { bugCount, stage } =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill, paddingXY 20 20 ]
            (case stage of
                Start ->
                    Main.View.Start.render bugCount Nothing

                GotFile file ->
                    Main.View.Start.render bugCount (Just file)

                Debugging { brokenFile, currentTab, encouragements } ->
                    Stages.Debugging.View.render
                        { bugCount = bugCount
                        , encouragements = encouragements
                        , brokenFile = brokenFile
                        , currentTab = currentTab
                        }

                Finished _ ->
                    none
            )
        ]
    }
