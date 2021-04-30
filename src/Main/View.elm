module Main.View exposing (render)

import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


render : Model -> { title : String, body : List (Html Msg) }
render _ =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill ]
            (row [ Font.color (rgb 0 0 0), width fill, height fill ]
                [ text "Select a file or folder"
                ]
            )
        ]
    }
