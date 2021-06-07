module Main.View exposing (render)

import Element exposing (..)
import Html exposing (Html)
import Main.Model exposing (Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.View.Start
import Stages.Debugging.Model exposing (HelpTab(..))
import Stages.Debugging.View
import Stages.Finished.Model
import Stages.Finished.View


render : Model -> { title : String, body : List (Html Msg) }
render { bugCount, stage } =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill, paddingXY 20 20 ]
            (case stage of
                Start ->
                    Main.View.Start.render bugCount Nothing

                GotFile file ->
                    Main.View.Start.render bugCount (Just file)

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
            )
        ]
    }
