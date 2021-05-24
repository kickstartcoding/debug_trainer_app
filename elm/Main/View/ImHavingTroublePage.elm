module Main.View.ImHavingTroublePage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Main.Model exposing (BrokenFile, DebuggingInterfaceTab(..), HintVisibility, Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath as FilePath exposing (FilePath)


render : Int -> BrokenFile -> Element Msg
render bugCount ({ changes, path } as brokenFile) =
    column [ width fill, height fill ]
        [ Input.button
            [ Background.color Colors.purple
            , Font.color Colors.white
            , Font.center
            , width (px 250)
            , paddingXY 35 20
            , rounded 5
            , moveUp 20
            ]
            { onPress = Just (ChangeInterfaceTab StepsPage brokenFile)
            , label = text "Back to main page"
            }
        , row [ width fill ]
            [ column [ width fill, height fill ]
                [ paragraph [ Font.size 30 ] [ text "Debugging Tips" ]
                , paragraph [] [ text "print out all of your variables" ]
                ]
            , column [ width fill, height fill ]
                [ paragraph [ Font.size 30 ] [ text "Give me a hint" ]
                , column [ spacing 20 ] (changes |> List.indexedMap (changeOptions brokenFile))
                ]
            ]
        ]


changeOptions : BrokenFile -> Int -> ( ChangeData, HintVisibility ) -> Element Msg
changeOptions brokenFile index ( change, hintVisibility ) =
    column [ spacing 10 ]
        [ paragraph [] [ text ("Bug " ++ String.fromInt (index + 1)) ]
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
                    , rounded 5
                    ]
                    { onPress = Just (ShowBugLineHint brokenFile index)
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
                    , rounded 5
                    ]
                    { onPress = Just (ShowBugTypeHint brokenFile index)
                    , label = paragraph [] [ text "Tell me what type of bug this one is" ]
                    }
        ]
