module Main exposing (main)

import Browser
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { bugCount = 1
      , stage = Start
      }
    , Cmd.none
    )


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = Main.View.render
        , update = Main.Update.update
        , subscriptions = Main.Subscriptions.subscriptions
        }
