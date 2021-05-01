module Main.Msg exposing (Msg(..))

import File exposing (File)


type Msg
    = UpdatebugCount String
    | ChooseFile
    | FileWasSelected File
