module Main.View exposing (render)

import Element exposing (..)
import Html exposing (Html)
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.View.Start
import Main.View.BrokenFile


render : Model -> { title : String, body : List (Html Msg) }
render { bugCount, stage } =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill, paddingXY 20 40 ]
            (case stage of
                Start ->
                    Main.View.Start.render bugCount Nothing

                GotFile file ->
                    Main.View.Start.render bugCount (Just file)

                BrokeFile file interface->
                    Main.View.BrokenFile.render bugCount file interface

                Finished _ ->
                    none
            )
        ]
    }
