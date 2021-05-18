module Main exposing (main)

import Browser
import Json.Decode exposing (Value)
import Main.Interop
import Main.Model exposing (Error(..), Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View
import Utils.Types.FilePath as FilePath


init : Value -> ( Model, Cmd Msg )
init flags =
    let
        ( randomNumbers, startingError ) =
            case Main.Interop.decodeFlags flags of
                Ok numbers ->
                    ( numbers, Nothing )

                Err error ->
                    ( [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ], Just (BadFlags error) )
    in
    ( { bugCount = 1
      , randomNumbers = randomNumbers

      -- , stage = Start
      , stage =
            GotFile
                { path = FilePath.fromString "/test/testfile.js"
                , content = "function a (a, b, c) { return c }; a()"
                }
      , maybeError = startingError
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
