module Stages.Debugging.View.HelpPage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Model as Model
    exposing
        ( HelpTab(..)
        , Page(..)
        )
import Stages.Debugging.Msg exposing (Msg(..))
import Stages.Debugging.View.HelpTabs.BugHints as BugHintsTab
import Stages.Debugging.View.HelpTabs.DebuggingTips as DebuggingTipsTab
import Stages.Debugging.View.HelpTabs.Encouragement as EncouragementTab
import Stages.Debugging.View.HelpTabs.ShowMeTheAnswer as ShowMeTheAnswerTab
import Utils.Colors as Colors
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.UI.Buttons as Buttons


render :
    { requestedBugCount : Int
    , encouragements : Encouragements
    , currentDebuggingTip : Int
    , currentHelpTab : HelpTab
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { requestedBugCount, currentDebuggingTip, encouragements, currentHelpTab, brokenFile } =
    column [ spacing 30, width fill, height fill ]
        [ Buttons.back { name = "back to instructions", msg = ChangePage StepsPage }
        , column [ width fill, height fill, spacing 20 ]
            [ row [ width fill ]
                [ renderTab
                    { tab = DebuggingTips
                    , isActive = DebuggingTips == currentHelpTab
                    }
                , renderTab
                    { tab = BugHints
                    , isActive = BugHints == currentHelpTab
                    }
                , renderTab
                    { tab = EncourageMe
                    , isActive = EncourageMe == currentHelpTab
                    }
                , renderTab
                    { tab = ShowMeTheAnswer
                    , isActive = ShowMeTheAnswer == currentHelpTab
                    }
                ]
            , case currentHelpTab of
                DebuggingTips ->
                    DebuggingTipsTab.render
                        { currentDebuggingTip = currentDebuggingTip
                        , brokenFile = brokenFile
                        }

                BugHints ->
                    BugHintsTab.render
                        { requestedBugCount = requestedBugCount
                        , brokenFile = brokenFile
                        }

                EncourageMe ->
                    EncouragementTab.render
                        { requestedBugCount = requestedBugCount
                        , encouragements = encouragements
                        , brokenFile = brokenFile
                        }

                ShowMeTheAnswer ->
                    ShowMeTheAnswerTab.render brokenFile
            ]
        ]


renderTab : { tab : HelpTab, isActive : Bool } -> Element Msg
renderTab { tab, isActive } =
    let
        { borderWidthBottom, paddingBottom, styles } =
            if isActive then
                { borderWidthBottom = 0
                , paddingBottom = 23
                , styles =
                    [ Border.color Colors.black
                    , Font.color Colors.black
                    ]
                }

            else
                { borderWidthBottom = 3
                , paddingBottom = 20
                , styles =
                    [ Border.color Colors.darkGray
                    , Font.color Colors.darkGray
                    , Background.color Colors.veryLightGray
                    ]
                }
    in
    column [ width fill ]
        [ Input.button
            (styles
                ++ [ Border.widthEach { bottom = 0, left = 3, right = 3, top = 3 }
                   , Border.roundEach { topLeft = 10, topRight = 10, bottomLeft = 0, bottomRight = 0 }
                   , Font.center
                   , width fill
                   , paddingEach { bottom = paddingBottom, left = 20, right = 20, top = 20 }
                   ]
            )
            { onPress = Just (ChangeHelpTab tab)
            , label = text (Model.helpTabToString tab)
            }
        , el
            [ width fill
            , Border.color Colors.black
            , Border.widthEach { bottom = borderWidthBottom, left = 0, right = 0, top = 0 }
            ]
            none
        ]
