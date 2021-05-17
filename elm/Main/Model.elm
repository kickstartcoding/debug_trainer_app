module Main.Model exposing
    ( BrokenFile
    , ChangeData
    , FilePath
    , Model
    , File
    , Stage(..)
    )

import Utils.Types.BreakType exposing (BreakType)


type alias Model =
    { bugCount : Int
    , stage : Stage
    }


type Stage
    = Start
    | GotFile File
    | BrokeFile BrokenFile
    | Finished BrokenFile


type alias File =
    { path : String
    , content : String
    }


type alias BrokenFile =
    { originalContent : String
    , updatedContent : String
    , changes : List ChangeData
    , path : FilePath
    }


type alias ChangeData =
    { lineNumber : Int
    , breakType : BreakType
    , changeDescription : String
    }


type FilePath
    = FilePath String
