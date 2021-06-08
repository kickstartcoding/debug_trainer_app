module Main.Update exposing (update)

import Main.Interop as Interop
import Main.Model
    exposing
        ( Error(..)
        , Model
        , Stage(..)
        )
import Main.Msg exposing (Msg(..))
import Main.Update.BreakFile as BreakFile
import Stages.ChooseFile.Model as ChooseFile exposing (File, StartType(..))
import Stages.ChooseFile.Msg
import Stages.ChooseFile.Update as ChooseFileUpdate exposing (Instruction(..))
import Stages.Debugging.Model
import Stages.Debugging.Update as DebuggingUpdate
import Stages.Finished.Update as FinishedUpdate
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath as FilePath


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LetsGetStarted ->
            ( { model | stage = ChooseFile ChooseFile.init }
            , Cmd.none
            )

        ChooseFileInterface beginningMsg ->
            case model.stage of
                ChooseFile beginningModel ->
                    let
                        { newModel, cmd, bubble } =
                            ChooseFileUpdate.update
                                { model = beginningModel
                                , msg = beginningMsg
                                }
                    in
                    case bubble.instruction of
                        Just (UpdateBugCountInstruction newBugCount) ->
                            ( { model
                                | stage = ChooseFile newModel
                                , bugCount = newBugCount
                              }
                            , Cmd.map ChooseFileInterface cmd
                            )

                        Just (BreakFileInstruction file) ->
                            breakFile file model cmd

                        Nothing ->
                            ( { model | stage = ChooseFile newModel }
                            , Cmd.map ChooseFileInterface cmd
                            )

                _ ->
                    ( model, Cmd.none )

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
                    case bubble.instruction of
                        Just (DebuggingUpdate.GoToFinishStage finishType) ->
                            ( { model
                                | stage =
                                    Finished
                                        { finishType = finishType
                                        , brokenFile = newModel.brokenFile
                                        }
                              }
                            , Cmd.map DebuggingInterface cmd
                            )

                        Just DebuggingUpdate.ResetAndPlayAgain ->
                            ( { model | stage = ChooseFile (ChooseFile.afterResetInit debuggingModel.brokenFile) }
                            , Cmd.batch
                                [ Cmd.map DebuggingInterface cmd
                                , Interop.writeFile
                                    { path = debuggingModel.brokenFile.path
                                    , content = debuggingModel.brokenFile.originalContent
                                    }
                                ]
                            )

                        Nothing ->
                            ( { model | stage = Debugging newModel }
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
                                    ( { model
                                        | stage =
                                            ChooseFile (ChooseFile.afterResetInit brokenFile)
                                      }
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


breakFile : File -> Model -> Cmd Stages.ChooseFile.Msg.Msg -> ( Model, Cmd Msg )
breakFile { path, content } model beginningCmd =
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
            , Cmd.batch
                [ Cmd.map ChooseFileInterface beginningCmd
                , Interop.writeFile
                    { path = path
                    , content = newFileContent
                    }
                ]
            )

        Nothing ->
            ( { model
                | maybeError =
                    Just
                        (CouldntBreakSelectedFile
                            (FilePath.toString path)
                        )
              }
            , Cmd.none
            )
