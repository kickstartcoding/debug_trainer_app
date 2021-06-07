module Main.Update exposing (update)

import List.Extra
import Main.Interop as Interop
import Main.Model exposing (Error(..), Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Update.BreakFile as BreakFile
import Stages.Debugging.Model
import Stages.Debugging.Update as DebuggingUpdate
import Stages.Finished.Update as FinishedUpdate
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath as FilePath


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateBugCount count ->
            case String.toInt count of
                Just bugCount ->
                    ( { model | bugCount = bugCount }, Cmd.none )

                Nothing ->
                    ( { model | maybeError = Just (CouldntParseBugCount count) }, Cmd.none )

        ChooseFile ->
            ( model, Interop.chooseFile () )

        FileWasSelected file ->
            ( { model | stage = GotFile file }, Cmd.none )

        BreakFile { path, content } ->
            let
                result =
                    BreakFile.run
                        { breakCount = model.bugCount
                        , filepath = path
                        , fileContent = content
                        , randomNumbers = model.randomNumbers
                        }
            in
            case result of
                Just { newFileContent, changes } ->
                    ( { model
                        | stage =
                            Debugging
                                (Stages.Debugging.Model.init
                                    { originalContent = content
                                    , updatedContent = newFileContent
                                    , changes = changes
                                    , path = path
                                    }
                                )
                      }
                    , Interop.writeFile
                        { path = path
                        , content = newFileContent
                        }
                    )

                Nothing ->
                    ( { model | maybeError = Just (CouldntBreakSelectedFile (FilePath.toString path)) }, Cmd.none )

        FileWasBroken ->
            ( model, Cmd.none )

        DebuggingInterface debuggingMsg ->
            case model.stage of
                Debugging debuggingModel ->
                    let
                        { newModel, cmd, bubble } =
                            DebuggingUpdate.update
                                { model = debuggingModel
                                , msg = debuggingMsg
                                }
                    in
                    ( case bubble.instruction of
                        Just (DebuggingUpdate.GoToFinishStage finishType) ->
                            { model
                                | stage =
                                    Finished
                                        { finishType = finishType
                                        , brokenFile = newModel.brokenFile
                                        }
                            }

                        Nothing ->
                            { model | stage = Debugging newModel }
                    , Cmd.map DebuggingInterface cmd
                    )

                _ ->
                    ( model, Cmd.none )

        FinishedInterface finishedMsg ->
            case model.stage of
                Finished ({ brokenFile } as finishedModel) ->
                    let
                        { newModel, cmd, bubble } =
                            FinishedUpdate.update
                                { model = finishedModel
                                , msg = finishedMsg
                                }
                    in
                    case bubble.instruction of
                        Just (FinishedUpdate.ResetFile playPreference) ->
                            case playPreference of
                                FinishedUpdate.PlayAgain ->
                                    ( { model | stage = Start }
                                    , Cmd.batch
                                        [ Cmd.map FinishedInterface cmd
                                        , Interop.writeFile
                                            { path = brokenFile.path
                                            , content = brokenFile.originalContent
                                            }
                                        ]
                                    )

                                FinishedUpdate.Exit ->
                                    ( { model | stage = Finished newModel }
                                    , Cmd.batch
                                        [ Cmd.map FinishedInterface cmd
                                        , Interop.writeFileAndExit
                                            { path = brokenFile.path
                                            , content = brokenFile.originalContent
                                            }
                                        ]
                                    )

                        Nothing ->
                            ( { model | stage = Finished newModel }
                            , Cmd.map FinishedInterface cmd
                            )

                _ ->
                    ( model, Cmd.none )

        InteropError error ->
            ( { model | maybeError = Just (BadInterop error) }, Cmd.none )
