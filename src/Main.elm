module Main exposing (main)

import Browser
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Update
import Main.View


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { fileCount = 1 }, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = Main.View.render
        , update = Main.Update.update
        , subscriptions = \_ -> Sub.none
        }
