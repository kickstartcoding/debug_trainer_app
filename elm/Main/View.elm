module Main.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
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


render : Model -> { title : String, body : List (Html Msg) }
render { bugCount, stage, maybeError, logo } =
    { title = "Debugging Trainer"
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
                            { bugCount = bugCount
                            , startType = startType
                            , status = status
                            }

                Debugging { brokenFile, currentPage, currentHelpTab, encouragements, currentDebuggingTip, answerIsShowing } ->
                    Element.map DebuggingInterface <|
                        Stages.Debugging.View.render
                            { bugCount = bugCount
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
