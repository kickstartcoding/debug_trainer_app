module Main.Msg exposing (Msg(..))

import Json.Decode
import Main.Model exposing (File)
import Stages.Debugging.Msg
import Stages.Finished.Msg


type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected File
    | BreakFile File
    | FileWasBroken
    | DebuggingInterface Stages.Debugging.Msg.Msg
    | FinishedInterface Stages.Finished.Msg.Msg
    | InteropError Json.Decode.Error
