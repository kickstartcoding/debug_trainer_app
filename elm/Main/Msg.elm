module Main.Msg exposing (Msg(..))

import Json.Decode
import Main.Model exposing (File)

type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected File
    | BreakFile File
    | FileWasBroken
    | InteropError Json.Decode.Error
