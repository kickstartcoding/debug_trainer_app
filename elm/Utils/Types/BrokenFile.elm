module Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)

import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath exposing (FilePath)


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
