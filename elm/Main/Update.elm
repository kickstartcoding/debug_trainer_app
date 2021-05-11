module Main.Update exposing (update)

import Main.Interop as Interop
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateBugCount count ->
            case String.toInt count of
                Just bugCount ->
                    ( { model | bugCount = bugCount }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChooseFile ->
            ( model, Interop.chooseFile () )

        FileWasSelected file ->
            ( model, Cmd.none )

        InteropError error ->
            ( model, Cmd.none )
