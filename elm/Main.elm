module Main exposing (main)

import Browser
import Json.Decode exposing (Value)
import Main.Interop
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View


init : Value -> ( Model, Cmd Msg )
init flags =
    ( { bugCount = 1
      , randomNumbers =
            case Main.Interop.decodeFlags flags of
                Ok randomNumbers ->
                    randomNumbers

                Err _ ->
                    []
      , stage = Start
      }
    , Cmd.none
    )


main : Program Value Model Msg
main =
    Browser.document
        { init = init
        , view = Main.View.render
        , update = Main.Update.update
        , subscriptions = Main.Subscriptions.subscriptions
        }
