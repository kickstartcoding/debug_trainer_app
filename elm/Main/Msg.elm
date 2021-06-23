module Main.Msg exposing (Msg(..))

import Json.Decode
import Main.Interop exposing (ToElm(..))
import Stages.ChooseFile.Msg
import Stages.Debugging.Msg
import Stages.Finished.Msg
import Utils.Types.BrokenFile exposing (BrokenFile)


type Msg
    = LetsGetStarted
    | ChooseFileInterface Stages.ChooseFile.Msg.Msg
    | FileWasBroken
    | DebuggingInterface Stages.Debugging.Msg.Msg
    | FinishedInterface Stages.Finished.Msg.Msg
    | GotNewRandomNumbers (List Int)
    | ExitShortcutWasPressed
    | Quit
    | QuitAndResetFile BrokenFile
    | CancelQuitRequest
    | InteropError Json.Decode.Error
