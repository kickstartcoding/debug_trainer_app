module Main.Msg exposing (Msg(..))

import Json.Decode
import Stages.ChooseFile.Msg
import Stages.Debugging.Msg
import Stages.Finished.Msg


type Msg
    = LetsGetStarted
    | ChooseFileInterface Stages.ChooseFile.Msg.Msg
    | FileWasBroken
    | DebuggingInterface Stages.Debugging.Msg.Msg
    | FinishedInterface Stages.Finished.Msg.Msg
    | GotNewRandomNumbers (List Int)
    | InteropError Json.Decode.Error
