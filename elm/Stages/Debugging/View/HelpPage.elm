module Stages.Debugging.View.HelpPage exposing (render)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Stages.Debugging.Model as Model exposing (HelpTab(..), Model, Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Stages.Debugging.View.HelpTabs.BugHints as BugHintsTab
import Stages.Debugging.View.HelpTabs.DebuggingTips as DebuggingTipsTab
import Stages.Debugging.View.HelpTabs.Encouragement as EncouragementTab
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FilePath as FilePath exposing (FilePath)
import Utils.Types.FileType as FileType exposing (FileType)


render :
    { bugCount : Int
    , encouragements : Encouragements
    , currentDebuggingTip : Int
    , currentHelpTab : HelpTab
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, currentDebuggingTip, encouragements, currentHelpTab, brokenFile } =
    let
        fileType =
            brokenFile.path |> FileType.fromFilePath
    in
    column [ spacing 30, width fill, height fill ]
        [ Input.button
            [ Background.color Colors.purple
            , Font.color Colors.white
            , Font.center
            , width (px 250)
            , paddingXY 35 20
            , Border.rounded 5
            ]
            { onPress = Just (ChangePage StepsPage)
            , label = row [] [ el [ Font.bold ] (text "‹"), text " Back to instructions" ]
            }
        , column [ width fill, height fill ]
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
                    { tab = ShowFile
                    , isActive = ShowFile == currentHelpTab
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
                        { bugCount = bugCount
                        , brokenFile = brokenFile
                        }

                EncourageMe ->
                    EncouragementTab.render
                        { bugCount = bugCount
                        , encouragements = encouragements
                        , brokenFile = brokenFile
                        }

                ShowFile ->
                    text "not done yet"
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
                    , Font.bold
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
