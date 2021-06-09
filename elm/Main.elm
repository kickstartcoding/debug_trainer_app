module Main exposing (main)

import Browser
import Json.Decode exposing (Value)
import Main.Interop
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View
import Process exposing (Id)
import Stages.Debugging.Model exposing (HelpTab(..), Page(..))
import Utils.DummyData as DummyData
import Utils.List
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.Encouragements as Encouragements exposing (Encouragements)
import Utils.Types.Error as Error
import Utils.Types.FilePath as FilePath


init : Value -> ( Model, Cmd Msg )
init flags =
    let
        { randomNumbers, startingError } =
            case Main.Interop.decodeFlags flags of
                Ok ((firstRandomNumber :: _) as numbers) ->
                    { randomNumbers = numbers
                    , startingError = Nothing
                    }

                Ok [] ->
                    { randomNumbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
                    , startingError =
                        Just
                            (Error.misc
                                { action = "initial flag decoding"
                                , descriptionForUsers = "Got an empty list of random numbers"
                                , error = "Got an empty list of random numbers"
                                , inModule = "Main"
                                }
                            )
                    }

                Err error ->
                    { randomNumbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
                    , startingError =
                        Just
                            (Error.decoding
                                { action = "initial flag decoding"
                                , descriptionForUsers = "Something went wrong loading this app"
                                , error = error
                                , inModule = "Main"
                                }
                            )
                    }
    in
    ( { bugCount = 1
      , randomNumbers = randomNumbers
      , stage = Intro

      --   , stage = DummyData.chooseFileStage
      --   , stage = DummyData.triedToStartBeforeChoosingAFileStage
      --   , stage = DummyData.gotFileStage
      --   , stage = DummyData.debuggingStageStepsPage randomNumbers
      -- , stage = DummyData.debuggingStageIDontSeeAnyErrorsPage randomNumbers
      --   , stage = DummyData.debuggingStageBugHintsTab randomNumbers
      -- , stage = DummyData.debuggingStageTipsTab randomNumbers
      -- , stage = DummyData.debuggingStageEncouragementTab randomNumbers
      -- , stage = DummyData.debuggingStageShowAnswerTab randomNumbers
      --   , stage = DummyData.successfulFinishStage randomNumbers
      -- , stage = DummyData.shownAnswerFinishedStage randomNumbers
      , maybeError = startingError
      }
    , Cmd.none
    )


main : Program Value Model Msg
main =
    Browser.document
        { init = init
        , view = Main.View.render
        , update = Main.Update.update
        , subscriptions = Main.Subscriptions.subscriptions
        }
