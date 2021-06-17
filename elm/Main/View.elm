module Main.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Stages.ChooseFile.View
import Stages.Debugging.Model exposing (HelpTab(..))
import Stages.Debugging.View
import Stages.Finished.View
import Stages.Intro.View
import Utils.Colors as Colors
import Utils.Constants as Constants


render : Model -> { title : String, body : List (Html Msg) }
render { requestedBugCount, stage, maybeError, logo } =
    { title = Constants.appName
    , body =
        [ layout
            [ width fill
            , height fill
            , paddingXY 20 20
            , inFront
                (case maybeError of
                    Just error ->
                        paragraph
                            [ alignBottom
                            , width fill
                            , Background.color Colors.red
                            , Font.color Colors.white
                            , Font.center
                            , Font.size 25
                            , paddingXY 30 15
                            ]
                            [ text error.descriptionForUsers ]

                    Nothing ->
                        none
                )
            ]
          <|
            case stage of
                Intro ->
                    Stages.Intro.View.render logo

                ChooseFile { startType, status } ->
                    Element.map ChooseFileInterface <|
                        Stages.ChooseFile.View.render
                            { requestedBugCount = requestedBugCount
                            , startType = startType
                            , status = status
                            }

                Debugging { brokenFile, currentPage, currentHelpTab, encouragements, currentDebuggingTip } ->
                    Element.map DebuggingInterface <|
                        Stages.Debugging.View.render
                            { requestedBugCount = requestedBugCount
                            , encouragements = encouragements
                            , brokenFile = brokenFile
                            , currentPage = currentPage
                            , currentHelpTab = currentHelpTab
                            , currentDebuggingTip = currentDebuggingTip
                            }

                Finished finishModel ->
                    Element.map FinishedInterface <|
                        Stages.Finished.View.render finishModel
        ]
    }
