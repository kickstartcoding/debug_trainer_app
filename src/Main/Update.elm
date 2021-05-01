module Main.Update exposing (update)

import File.Select
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatebugCount count ->
            case String.toInt count of
                Just bugCount ->
                    ( { model | bugCount = bugCount }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChooseFile ->
            ( model, File.Select.file [ "*" ] FileWasSelected )

        FileWasSelected file ->
            ( model, Cmd.none )
