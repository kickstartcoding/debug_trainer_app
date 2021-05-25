module Stages.Debugging.View.ImHavingTroublePage exposing (render)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Stages.Debugging.Model exposing (Model, Tab(..))
import Stages.Debugging.Msg exposing (Msg(..))
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
    , encouragementIsShowing : Bool
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, encouragementIsShowing, brokenFile } =
    let
        fileType =
            brokenFile.path |> FileType.fromFilePath
    in
    column [ width fill, height fill, spacing 30 ]
        [ Input.button
            [ Background.color Colors.purple
            , Font.color Colors.white
            , Font.center
            , width (px 250)
            , paddingXY 35 20
            , Border.rounded 5
            ]
            { onPress = Just (ChangeTab StepsPage)
            , label = row [] [ el [ Font.bold ] (text "‹"), text " Back to instructions" ]
            }
        , row [ width fill, spacing 40 ]
            [ column [ width fill, height fill, spacing 30 ]
                [ paragraph [ Font.size 30 ] [ text "Debugging Tips" ]
                , column [ spacing 20, Background.color Colors.lightGray, Border.rounded 5, paddingXY 20 20 ]
                    [ paragraph [] [ text "Find the line number in the error message and check that part of the file first." ]
                    ]
                , column [ spacing 20, Background.color Colors.lightGray, Border.rounded 5, paddingXY 20 20 ]
                    [ paragraph [] [ text "Print out the variables in your program — even if you think you know what they all are, some of them may surprise you!" ]
                    , paragraph []
                        [ text "In "
                        , el [ Font.bold ] (text (FileType.toString fileType))
                        , text " you can use "
                        , el [ Font.bold ] (text (FileType.toPrintFunctionName fileType))
                        , text " for this."
                        ]
                    ]
                ]
            , column [ width fill, height fill, spacing 10 ]
                [ paragraph [ Font.size 30 ] [ text "Give me a hint" ]
                , column [ spacing 20, scrollbarX, width fill, height fill ]
                    (brokenFile.changes
                        |> List.indexedMap
                            (changeOptions
                                { brokenFile = brokenFile
                                , encouragementIsShowing = encouragementIsShowing
                                }
                            )
                    )
                ]
            ]
        , row [ Font.center, height (px 100), spacing 20, width fill ] <|
            if encouragementIsShowing then
                [ Input.button
                    [ Background.color Colors.purple
                    , Font.color Colors.white
                    , Font.center
                    , paddingXY 35 20
                    , Border.rounded 5
                    ]
                    { onPress = Just SaySomethingEncouraging
                    , label = text "Say something else encouraging"
                    }
                , paragraph [ width fill ]
                    [ text
                        (encouragements.list
                            |> Array.fromList
                            |> Array.get encouragements.current
                            |> Maybe.withDefault "You're doing great!"
                        )
                    ]
                ]

            else
                [ Input.button
                    [ Background.color Colors.purple
                    , Font.color Colors.white
                    , Font.center
                    , paddingXY 35 20
                    , Border.rounded 5
                    ]
                    { onPress = Just SaySomethingEncouraging
                    , label = text "Say something encouraging"
                    }
                ]
        ]


changeOptions :
    { brokenFile : BrokenFile
    , encouragementIsShowing : Bool
    }
    -> Int
    -> ( ChangeData, HintVisibility )
    -> Element Msg
changeOptions { brokenFile, encouragementIsShowing } index ( change, hintVisibility ) =
    column [ spacing 10 ]
        [ if List.length brokenFile.changes > 1 then
            paragraph [ Font.bold ] [ text ("Bug " ++ String.fromInt (index + 1)) ]

          else
            none
        , el [ height (px 80) ] <|
            if hintVisibility.showingLineNumber then
                paragraph [ centerY ] [ text ("this bug was introduced on line " ++ String.fromInt change.lineNumber ++ " of the original file") ]

            else
                Input.button
                    [ Background.color Colors.purple
                    , Font.color Colors.white
                    , Font.center
                    , width (px 250)
                    , paddingXY 35 20
                    , Border.rounded 5
                    ]
                    { onPress = Just (ShowBugLineHint index)
                    , label = paragraph [] [ text "Show me what line this bug is on" ]
                    }
        , el [ height (px 80) ] <|
            if hintVisibility.showingBugType then
                paragraph [ centerY ] [ text change.changeDescription ]

            else
                Input.button
                    [ Background.color Colors.purple
                    , Font.color Colors.white
                    , Font.center
                    , width (px 250)
                    , paddingXY 35 20
                    , Border.rounded 5
                    ]
                    { onPress = Just (ShowBugTypeHint index)
                    , label = paragraph [] [ text "Tell me what type of bug this is" ]
                    }
        ]
