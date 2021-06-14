module Stages.Finished.Update exposing
    ( Instruction(..)
    , PlayPreference(..)
    , update
    )

import Stages.Finished.Model exposing (Model)
import Stages.Finished.Msg exposing (Msg(..))
import Utils.BubbleUp as BubbleUp exposing (BubbleUpWithInstruction)


type Instruction
    = ResetFile PlayPreference


type PlayPreference
    = PlayAgain
    | Exit


update : { model : Model, msg : Msg } -> BubbleUpWithInstruction Model Msg Instruction
update { model, msg } =
    case msg of
        ResetFileAndExit ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withInstruction (ResetFile Exit)

        ResetFileAndPlayAgain ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withInstruction (ResetFile PlayAgain)
