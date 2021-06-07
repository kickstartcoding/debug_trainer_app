module Stages.Finished.Model exposing
    ( FinishType(..)
    , Model
    )

import Utils.Types.BrokenFile exposing (BrokenFile)


type alias Model =
    { brokenFile : BrokenFile
    , finishType : FinishType
    }


type FinishType
    = SuccessfullySolved
    | AskedToSeeAnswer
