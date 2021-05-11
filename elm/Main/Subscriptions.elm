module Main.Subscriptions exposing (subscriptions)

import Main.Interop as Interop
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Interop.toElm
        |> Sub.map
            (\toElm ->
                case toElm of
                    Interop.GotFileChoice file ->
                        FileWasSelected file
            )
