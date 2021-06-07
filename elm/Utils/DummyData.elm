module Utils.DummyData exposing (..)

import Main.Model exposing (Error(..), Stage(..))
import Main.Update.BreakFile as BreakFile
import Stages.Debugging.Model as DebuggingModel
    exposing
        ( HelpTab(..)
        , Page(..)
        )
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements as Encouragements
import Utils.Types.FilePath as FilePath exposing (FilePath)


startStage : Stage
startStage =
    Start


gotFileStage : Stage
gotFileStage =
    GotFile
        { path = defaultFilePath
        , content = defaultFileContent
        }


debuggingStageStepsPage : List Int -> Stage
debuggingStageStepsPage randomNumbers =
    let
        model =
            debuggingModel randomNumbers
    in
    Debugging
        { model | currentPage = StepsPage }


debuggingStageIDontSeeAnyErrorsPage : List Int -> Stage
debuggingStageIDontSeeAnyErrorsPage randomNumbers =
    let
        model =
            debuggingModel randomNumbers
    in
    Debugging
        { model | currentPage = IDontSeeAnyErrorsPage }


debuggingStageBugHintsTab : List Int -> Stage
debuggingStageBugHintsTab randomNumbers =
    let
        model =
            debuggingModel randomNumbers
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
            debuggingModel randomNumbers
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
            debuggingModel randomNumbers
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
            debuggingModel randomNumbers
    in
    Debugging
        { model
            | currentPage = HelpPage
            , currentHelpTab = ShowMeTheAnswer
        }


debuggingModel : List Int -> DebuggingModel.Model
debuggingModel randomNumbers =
    { currentPage = HelpPage
    , currentHelpTab = ShowMeTheAnswer
    , currentDebuggingTip = 0
    , answerIsShowing = True
    , encouragements = Encouragements.init (randomNumbers |> List.head |> Maybe.withDefault 0)
    , brokenFile =
        { originalContent = "function a (a, b, c)\n{\n  return c\n}\n\na()\n"
        , updatedContent = "function a (b, a, c)\n{\n  c\n}\n\na()\n"
        , changes =
            [ ( { lineNumber = 1
                , breakType = ChangeFunctionArgs
                , changeDescription = "swapped some goddamn args"
                }
              , { showingLineNumber = False
                , showingBugType = False
                }
              )
            , ( { lineNumber = 5
                , breakType = RemoveParenthesis
                , changeDescription = "removed a paren"
                }
              , { showingLineNumber = False
                , showingBugType = False
                }
              )
            , ( { lineNumber = 5
                , breakType = RemoveParenthesis
                , changeDescription = "removed a paren"
                }
              , { showingLineNumber = False
                , showingBugType = False
                }
              )
            ]
        , path = FilePath.fromString "testfile.js"
        }
    }


defaultDebugModel : List Int -> DebuggingModel.Model
defaultDebugModel randomNumbers =
    { currentPage = HelpPage
    , currentHelpTab = ShowMeTheAnswer
    , currentDebuggingTip = 0
    , answerIsShowing = True
    , encouragements = Encouragements.init (randomNumbers |> List.head |> Maybe.withDefault 0)
    , brokenFile = defaultBrokenFile randomNumbers
    }


finishedStage : List Int -> Stage
finishedStage randomNumbers =
    Finished (defaultBrokenFile randomNumbers)


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



-- { originalContent = "function a (a, b, c)\n{\n  return c\n}\n\na()\n"
-- , updatedContent = "function a (b, a, c)\n{\n  c\n}\n\na()\n"
-- , changes =
--     [ ( { lineNumber = 1
--         , breakType = ChangeFunctionArgs
--         , changeDescription = "swapped some goddamn args"
--         }
--       , { showingLineNumber = False
--         , showingBugType = False
--         }
--       )
--     , ( { lineNumber = 5
--         , breakType = RemoveParenthesis
--         , changeDescription = "removed a paren"
--         }
--       , { showingLineNumber = False
--         , showingBugType = False
--         }
--       )
--     , ( { lineNumber = 5
--         , breakType = RemoveParenthesis
--         , changeDescription = "removed a paren"
--         }
--       , { showingLineNumber = False
--         , showingBugType = False
--         }
--       )
--     ]
-- , path = FilePath.fromString "testfile.js"
-- }


defaultFilePath : FilePath
defaultFilePath =
    FilePath.fromString "/test/testfile.js"


defaultFileContent : String
defaultFileContent =
    "function a (a, b, c) {\n  return c\n}\na()\n"
