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
import Utils.Constants as Constants
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.UI.Buttons as Buttons


render : Model -> { title : String, body : List (Html Msg) }
render ({ maybeError } as model) =
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
            (renderViewByStage model)
        ]
    }


exitMenu : BrokenFile -> Element Msg
exitMenu brokenFile =
    column
        [ centerX
        , centerY
        , spacing 40
        , paddingXY 40 0
        , Font.center
        ]
        [ paragraph [ Font.size 30 ] [ text "Quit Menu" ]
        , paragraph []
            [ text "You pressed the \"quit\" shortcut before resetting the broken file. "
            , redText
                ("If you quit without resetting the file, "
                    ++ Constants.appName
                    ++ " will not be able to remove any bugs that are still in the file. What do you want to do?"
                )
            ]
        , column [ spacing 15, centerX ]
            [ Buttons.button [ centerX, width (px 320), Background.color Colors.green ]
                { name = "quit and reset the file"
                , msg = QuitAndResetFile brokenFile
                }
            , Buttons.button [ centerX, width (px 320), Background.color Colors.red ]
                { name = "quit without resetting the file"
                , msg = Quit
                }
            , Buttons.button [ centerX, width (px 320) ]
                { name = "go back"
                , msg = CancelQuitRequest
                }
            ]
        , paragraph [ Font.center, centerX, width (px 450) ]
            [ text "You can also "
            , redText "press the \"quit\" shortcut one more time to quit without resetting the file."
            ]
        ]


redText : String -> Element msg
redText content =
    el
        [ Background.color Colors.red
        , Font.color Colors.white
        , paddingXY 7 3
        , Border.rounded 4
        ]
        (text content)


renderViewByStage : Model -> Element Msg
renderViewByStage { requestedBugCount, stage, showExitMenu, logo } =
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
            if showExitMenu then
                exitMenu brokenFile

            else
                Element.map DebuggingInterface <|
                    Stages.Debugging.View.render
                        { requestedBugCount = requestedBugCount
                        , encouragements = encouragements
                        , brokenFile = brokenFile
                        , currentPage = currentPage
                        , currentHelpTab = currentHelpTab
                        , currentDebuggingTip = currentDebuggingTip
                        }

        Finished ({ brokenFile } as finishModel) ->
            if showExitMenu then
                exitMenu brokenFile

            else
                Element.map FinishedInterface <|
                    Stages.Finished.View.render finishModel
