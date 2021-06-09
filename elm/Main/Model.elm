module Main.Model exposing
    ( Model
    , Stage(..)
    )

import Json.Decode
import Stages.ChooseFile.Model
import Stages.Debugging.Model
import Stages.Finished.Model
import Utils.Types.Error exposing (Report)


type alias Model =
    { bugCount : Int
    , randomNumbers : List Int
    , stage : Stage
    , maybeError : Maybe Report
    }


type Stage
    = Intro
    | ChooseFile Stages.ChooseFile.Model.Model
    | Debugging Stages.Debugging.Model.Model
    | Finished Stages.Finished.Model.Model
