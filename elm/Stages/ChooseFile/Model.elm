module Stages.ChooseFile.Model exposing
    ( File
    , Model
    , StartType(..)
    , Status(..)
    , afterResetInit
    , init
    )

import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.FilePath exposing (FilePath)


type alias Model =
    { startType : StartType
    , status : Status
    }


init : Model
init =
    { startType = FirstTime
    , status = JustStarted
    }


afterResetInit : BrokenFile -> Model
afterResetInit brokenFile =
    { startType = AfterFileReset
    , status =
        GotFile
            { path = brokenFile.path
            , content = brokenFile.originalContent
            }
    }


type Status
    = JustStarted
    | GotFile File


type alias File =
    { path : FilePath
    , content : String
    }


type StartType
    = FirstTime
    | AfterFileReset
