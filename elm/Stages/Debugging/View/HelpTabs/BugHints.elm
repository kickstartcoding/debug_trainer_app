module Stages.Debugging.View.HelpTabs.BugHints exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.List
import Utils.String
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.UI.Buttons as Buttons


render : { bugCount : Int, brokenFile : BrokenFile } -> Element Msg
render { bugCount, brokenFile } =
    column [ width fill, height fill, scrollbarY, spacing 50, paddingXY 30 50 ]
        (brokenFile.changes
            |> List.indexedMap (changeOptions brokenFile)
            |> Utils.List.groupsOf 2
            |> List.map
                (row
                    [ spacing 40
                    , width fill
                    , height fill
                    ]
                )
        )


changeOptions : BrokenFile -> Int -> ( ChangeData, HintVisibility ) -> Element Msg
changeOptions brokenFile index ( change, hintVisibility ) =
    let
        { header, thisBugText, thisOrItText } =
            if List.length brokenFile.changes > 1 then
                { header = paragraph [ Font.bold, Font.center ] [ text ("Bug " ++ String.fromInt (index + 1)) ]
                , thisBugText = "this bug"
                , thisOrItText = "this"
                }

            else
                { header = none
                , thisBugText = "the bug"
                , thisOrItText = "it"
                }
    in
    column [ spacing 15, width fill, width (px 250), centerX ]
        [ header
        , el [ height (px 80) ] <|
            if hintVisibility.showingLineNumber then
                paragraph [ centerY ] [ text (thisBugText ++ " was introduced on line " ++ String.fromInt change.lineNumber ++ " of the original file") ]

            else
                Buttons.button []
                    { msg = ShowBugLineHint index
                    , name = "Show me what line " ++ thisBugText ++ " is on"
                    }
        , el [ height (px 80) ] <|
            if hintVisibility.showingBugType then
                paragraph [ centerY, spacing 5 ] (Utils.String.toFormattedElements change.changeDescription)

            else
                Buttons.button []
                    { msg = ShowBugTypeHint index
                    , name = "Tell me what type of bug " ++ thisOrItText ++ " is"
                    }
        ]
