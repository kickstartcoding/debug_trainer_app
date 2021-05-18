module Main.Msg exposing (Msg(..))

import Json.Decode
import Main.Model exposing (BrokenFile, DebuggingInterfaceTab, File)


type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected File
    | BreakFile File
    | FileWasBroken
    | ChangeInterfaceTab DebuggingInterfaceTab BrokenFile
    | InteropError Json.Decode.Error
