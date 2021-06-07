module Main.Model exposing
    ( Error(..)
    , File
    , Model
    , Stage(..)
    )

import Json.Decode
import Stages.Debugging.Model
import Stages.Finished.Model
import Utils.Types.BrokenFile exposing (BrokenFile)
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
    | Debugging Stages.Debugging.Model.Model
    | Finished Stages.Finished.Model.Model



type Error
    = CouldntParseBugCount String
    | CouldntBreakSelectedFile String
    | BadFlags String
    | BadInterop Json.Decode.Error


type alias File =
    { path : FilePath
    , content : String
    }
