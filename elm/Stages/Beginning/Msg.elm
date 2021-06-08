module Stages.Beginning.Msg exposing (Msg(..))

import Stages.Beginning.Model exposing (File)


type Msg
    = UpdateBugCount String
    | ChooseFile
    | FileWasSelected File
    | BreakFile File
