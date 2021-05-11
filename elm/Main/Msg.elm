module Main.Msg exposing (Msg(..))

import Json.Decode


type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected String
    | InteropError Json.Decode.Error
