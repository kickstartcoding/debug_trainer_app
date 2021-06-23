module Utils.DummyData exposing (..)

import Main.Model exposing (Stage(..))
import Main.Update.BreakFile as BreakFile
import Stages.ChooseFile.Model exposing (StartType(..), Status(..))
import Stages.Debugging.Model as DebuggingModel
    exposing
        ( HelpTab(..)
        , Page(..)
        )
import Stages.Finished.Model exposing (FinishType(..))
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements as Encouragements
import Utils.Types.FilePath as FilePath exposing (FilePath)


introStage : Stage
introStage =
    Intro


chooseFileStage : Stage
chooseFileStage =
    ChooseFile Stages.ChooseFile.Model.init


gotFileStage : Stage
gotFileStage =
    ChooseFile
        { startType = FirstTime
        , status =
            GotFile
                { path = defaultFilePath
                , content = defaultFileContent
                }
        }


debuggingStageStepsPage : List Int -> Stage
debuggingStageStepsPage randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model | currentPage = StepsPage }


debuggingStageIDontSeeAnyErrorsPage : List Int -> Stage
debuggingStageIDontSeeAnyErrorsPage randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model | currentPage = IDontSeeAnyErrorsPage }


debuggingStageBugHintsTab : List Int -> Stage
debuggingStageBugHintsTab randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model
            | currentPage = HelpPage
            , currentHelpTab = BugHints
        }


debuggingStageTipsTab : List Int -> Stage
debuggingStageTipsTab randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model
            | currentPage = HelpPage
            , currentHelpTab = DebuggingTips
        }


debuggingStageEncouragementTab : List Int -> Stage
debuggingStageEncouragementTab randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model
            | currentPage = HelpPage
            , currentHelpTab = EncourageMe
        }


debuggingStageShowAnswerTab : List Int -> Stage
debuggingStageShowAnswerTab randomNumbers =
    let
        model =
            defaultDebugModel randomNumbers
    in
    Debugging
        { model
            | currentPage = HelpPage
            , currentHelpTab = ShowMeTheAnswer
        }


defaultDebugModel : List Int -> DebuggingModel.Model
defaultDebugModel randomNumbers =
    { currentPage = HelpPage
    , currentHelpTab = ShowMeTheAnswer
    , currentDebuggingTip = 0
    , encouragements = Encouragements.init (randomNumbers |> List.head |> Maybe.withDefault 0)
    , brokenFile = defaultBrokenFile randomNumbers
    }


successfulFinishStage : List Int -> Stage
successfulFinishStage randomNumbers =
    Finished
        { finishType = SuccessfullySolved
        , brokenFile = defaultBrokenFile randomNumbers
        }


shownAnswerFinishedStage : List Int -> Stage
shownAnswerFinishedStage randomNumbers =
    Finished
        { finishType = AskedToSeeAnswer
        , brokenFile = defaultBrokenFile randomNumbers
        }


defaultBrokenFile : List Int -> BrokenFile
defaultBrokenFile randomNumbers =
    let
        result =
            BreakFile.run
                { breakCount = 3
                , filepath = defaultFilePath
                , fileContent = defaultFileContent
                , randomNumbers = randomNumbers
                }
    in
    case result of
        Just { newFileContent, changes } ->
            { originalContent = defaultFileContent
            , updatedContent = newFileContent
            , changes =
                changes
                    |> List.map
                        (\change ->
                            ( change
                            , { showingLineNumber = False
                              , showingBugType = False
                              }
                            )
                        )
            , path = defaultFilePath
            }

        Nothing ->
            { originalContent = defaultFileContent
            , updatedContent = defaultFileContent
            , changes =
                [ ( { lineNumber = 1
                    , breakType = ChangeFunctionArgs
                    , changeDescription = "DID SOME FAKE CHANGE"
                    }
                  , { showingLineNumber = False
                    , showingBugType = False
                    }
                  )
                ]
            , path = defaultFilePath
            }


defaultFilePath : FilePath
defaultFilePath =
    FilePath.fromString "/Users/SomeUser/long_file_path/with_a_lot_of_levels/testFile.js"


defaultFileContent : String
defaultFileContent =
    "function fileWithAVeryVeryVeryVeryVeryVeryVeryVeryLongName (a, b, c) {\n  return c\n}\na()\n"



-- defaultFileContent : String
-- defaultFileContent =
--     "function a (a, b, c) {\n  return c\n}\na()\n"
