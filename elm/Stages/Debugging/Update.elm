module Stages.Debugging.Update exposing (..)

import Stages.Debugging.Model as Model exposing (Model, Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Stages.Finished.Model exposing (FinishType(..))
import Utils.BubbleUp as BubbleUp exposing (BubbleUpWithInstruction)
import Utils.List
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements as Encouragements exposing (Encouragements)


type Instruction
    = GoToFinishStage FinishType


update : { model : Model, msg : Msg } -> BubbleUpWithInstruction Model Msg Instruction
update { model, msg } =
    case msg of
        ChangePage newPage ->
            { model | currentPage = newPage }
                |> BubbleUp.justModel

        ChangeHelpTab newTab ->
            { model | currentHelpTab = newTab }
                |> BubbleUp.justModel

        SwitchToNextEncouragement ->
            { model | encouragements = Encouragements.switchToNext model.encouragements }
                |> BubbleUp.justModel

        SwitchToNextDebuggingTip ->
            { model | currentDebuggingTip = model.currentDebuggingTip + 1 }
                |> BubbleUp.justModel

        SwitchToPreviousDebuggingTip ->
            { model | currentDebuggingTip = model.currentDebuggingTip - 1 }
                |> BubbleUp.justModel

        ShowBugLineHint bugIndex ->
            Model.updateChange bugIndex Model.showBugLineHint model
                |> BubbleUp.justModel

        ShowBugTypeHint bugIndex ->
            Model.updateChange bugIndex Model.showBugTypeHint model
                |> BubbleUp.justModel

        ShowTheAnswer ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withInstruction (GoToFinishStage AskedToSeeAnswer)

        ISolvedIt ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withInstruction (GoToFinishStage SuccessfullySolved)
