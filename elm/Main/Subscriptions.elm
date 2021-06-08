module Main.Subscriptions exposing (subscriptions)

import Main.Interop as Interop
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Stages.Beginning.Msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Interop.toElm
        |> Sub.map
            (\toElm ->
                case toElm of
                    Ok (Interop.GotFileChoice file) ->
                        BeginningInterface
                            (Stages.Beginning.Msg.FileWasSelected file)

                    Ok (Interop.FileChangeWasSaved ()) ->
                        FileWasBroken

                    Err error ->
                        InteropError error
            )
