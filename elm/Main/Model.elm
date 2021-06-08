module Main.Model exposing
    ( Error(..)
    , Model
    , Stage(..)
    )

import Json.Decode
import Stages.Beginning.Model
import Stages.Debugging.Model
import Stages.Finished.Model


type alias Model =
    { bugCount : Int
    , randomNumbers : List Int
    , stage : Stage
    , maybeError : Maybe Error
    }


type Stage
    = Beginning Stages.Beginning.Model.Model
    | Debugging Stages.Debugging.Model.Model
    | Finished Stages.Finished.Model.Model


type Error
    = CouldntParseBugCount String
    | CouldntBreakSelectedFile String
    | BadFlags String
    | BadInterop Json.Decode.Error
