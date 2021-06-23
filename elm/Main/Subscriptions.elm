module Main.Subscriptions exposing (subscriptions)

import Main.Interop as Interop
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Stages.ChooseFile.Msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Interop.toElm
        |> Sub.map
            (\toElm ->
                case toElm of
                    Ok (Interop.GotFileChoice file) ->
                        ChooseFileInterface
                            (Stages.ChooseFile.Msg.FileWasSelected file)

                    Ok (Interop.FileChangeWasSaved ()) ->
                        FileWasBroken

                    Ok (Interop.ExitShortcutWasPressed ()) ->
                        ExitShortcutWasPressed

                    Err error ->
                        InteropError error
            )
