module Stages.ChooseFile.Msg exposing (Msg(..))

import Stages.ChooseFile.Model exposing (File)


type Msg
    = UpdateBugCount String
    | PrematureStart
    | ChooseFile
    | FileWasSelected File
    | BreakFile File
