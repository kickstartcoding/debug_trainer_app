module Main.Update exposing (update)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFileCount count ->
            case String.toInt count of
                Just fileCount ->
                    ( { model | fileCount = fileCount }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )
