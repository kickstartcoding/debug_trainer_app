module Stages.Debugging.Update exposing (..)

import Stages.Debugging.Model as Model exposing (Model, Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.List
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements as Encouragements exposing (Encouragements)


update : { model : Model, msg : Msg } -> ( Model, Cmd Msg )
update { model, msg } =
    case msg of
        ChangePage newPage ->
            ( { model | currentPage = newPage }, Cmd.none )

        ChangeHelpTab newTab ->
            ( { model | currentHelpTab = newTab }
            , Cmd.none
            )

        SwitchToNextEncouragement ->
            ( { model | encouragements = Encouragements.switchToNext model.encouragements }
            , Cmd.none
            )

        SwitchToNextDebuggingTip ->
            ( { model | currentDebuggingTip = model.currentDebuggingTip + 1 }
            , Cmd.none
            )

        SwitchToPreviousDebuggingTip ->
            ( { model | currentDebuggingTip = model.currentDebuggingTip - 1 }
            , Cmd.none
            )

        ShowBugLineHint bugIndex ->
            ( Model.updateChange bugIndex Model.showBugLineHint model
            , Cmd.none
            )

        ShowBugTypeHint bugIndex ->
            ( Model.updateChange bugIndex Model.showBugTypeHint model
            , Cmd.none
            )

        ShowTheAnswer ->
            ( { model | answerIsShowing = True }
            , Cmd.none
            )
