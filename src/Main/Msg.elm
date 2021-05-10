module Main.Msg exposing (Msg(..))

import File exposing (File)


type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected File
