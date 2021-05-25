module Stages.Debugging.Update exposing (..)

import Stages.Debugging.Model as Model exposing (Model, Tab(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements as Encouragements exposing (Encouragements)


update : { model : Model, msg : Msg } -> ( Model, Cmd Msg )
update { model, msg } =
    case msg of
        -- ChangeTab newTab ->
        --     ( model, Cmd.none )
        -- ShowBugLineHint bugIndex ->
        --     ( model, Cmd.none )
        -- ShowBugTypeHint bugIndex ->
        --     ( model, Cmd.none )
        -- SaySomethingEncouraging ->
        --     ( model, Cmd.none )
        ChangeTab newTab ->
            ( { model | currentTab = newTab }, Cmd.none )

        SaySomethingEncouraging ->
            ( { model
                | encouragements = Encouragements.switchToNext model.encouragements
                , currentTab = ImHavingTroublePage True
              }
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
