module Main.Msg exposing (Msg(..))

import Json.Decode
import Stages.Beginning.Msg
import Stages.Debugging.Msg
import Stages.Finished.Msg


type Msg
    = BeginningInterface Stages.Beginning.Msg.Msg
    | FileWasBroken
    | DebuggingInterface Stages.Debugging.Msg.Msg
    | FinishedInterface Stages.Finished.Msg.Msg
    | InteropError Json.Decode.Error
