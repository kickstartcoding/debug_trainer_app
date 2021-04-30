module Main.Update exposing (update)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( (), Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
