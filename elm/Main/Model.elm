module Main.Model exposing
    ( BrokenFile
    , ChangeData
    , File
    , Model
    , Stage(..)
    )

import Utils.Types.BreakType exposing (BreakType)
import Utils.Types.FilePath exposing (FilePath)

type alias Model =
    { bugCount : Int
    , randomNumbers : List Int
    , stage : Stage
    }


type Stage
    = Start
    | GotFile File
    | BrokeFile BrokenFile
    | Finished BrokenFile


type alias File =
    { path : FilePath
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

