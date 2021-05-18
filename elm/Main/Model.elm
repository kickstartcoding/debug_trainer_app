module Main.Model exposing
    ( BrokenFile
    , DebuggingInterfaceTab(..)
    , Error(..)
    , File
    , Model
    , Stage(..)
    )

import Json.Decode
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath exposing (FilePath)


type alias Model =
    { bugCount : Int
    , randomNumbers : List Int
    , stage : Stage
    , maybeError : Maybe Error
    }


type Stage
    = Start
    | GotFile File
    | BrokeFile BrokenFile DebuggingInterfaceTab
    | Finished BrokenFile


type DebuggingInterfaceTab
    = StepsPage
    | ImHavingTroublePage


type Error
    = CouldntParseBugCount String
    | CouldntBreakSelectedFile String
    | BadFlags Json.Decode.Error
    | BadInterop Json.Decode.Error


type alias File =
    { path : FilePath
    , content : String
    }


type alias BrokenFile =
    { originalContent : String
    , updatedContent : String
    , changes : List ( ChangeData, HintVisibility )
    , path : FilePath
    }


type alias HintVisibility =
    { showingLineNumber : Bool
    , showingBugType : Bool
    }
