module Main.Update exposing (update)

import Main.Interop as Interop
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Update.BreakFile as BreakFile


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

        FileWasSelected { path, content } ->
            let
                result =
                    BreakFile.run
                        { breakCount = model.bugCount
                        , filepath = path
                        , fileContent = content
                        , randomNumbers = []
                        }
            in
            case result of
                Just { newFileContent } ->
                    ( model
                    , Interop.writeFile
                        { path = path
                        , content = newFileContent
                        }
                    )

                Nothing ->
                    ( model, Cmd.none )

        FileWasBroken ->
            ( model, Cmd.none )

        InteropError error ->
            ( model, Cmd.none )
