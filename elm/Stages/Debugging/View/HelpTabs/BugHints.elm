module Stages.Debugging.View.HelpTabs.BugHints exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)


render : { bugCount : Int, brokenFile : BrokenFile } -> Element Msg
render { bugCount, brokenFile } =
    column [ width fill, height fill ]
        [ row [ width fill ]
            [ column [ spacing 20 ] (brokenFile.changes |> List.indexedMap (changeOptions brokenFile))
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
                    , label = paragraph [] [ text "Tell me what type of bug this one is" ]
                    }
        ]
