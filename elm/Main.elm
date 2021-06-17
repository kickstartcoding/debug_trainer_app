module Main exposing (main)

import Browser
import Json.Decode exposing (Value)
import Main.Interop
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View
import Stages.Debugging.Model exposing (HelpTab(..), Page(..))
import Utils.Constants as Constants
import Utils.Types.AppMode exposing (AppMode(..))
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.Error as Error
import Utils.DevModeStartState as DevModeStartState

init : Value -> ( Model, Cmd Msg )
init flags =
    let
        { numbers, startingError, logoPath, appMode } =
            case Main.Interop.decodeFlags flags of
                Ok { randomNumbers, logo, mode } ->
                    { numbers = randomNumbers
                    , logoPath = logo
                    , startingError = Nothing
                    , appMode = mode
                    }

                Err error ->
                    { numbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
                    , logoPath = "/logo.e9a9c890.png"
                    , startingError =
                        Just
                            (Error.decoding
                                { action = "initial flag decoding"
                                , descriptionForUsers = "Something went wrong loading " ++ Constants.appName
                                , error = error
                                , inModule = "Main"
                                }
                            )
                    , appMode = Production
                    }
    in
    ( { requestedBugCount = 1
      , logo = logoPath
      , randomNumbers = numbers
      , stage =
            case appMode of
                Production ->
                    Intro

                Development ->
                    DevModeStartState.get numbers
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
