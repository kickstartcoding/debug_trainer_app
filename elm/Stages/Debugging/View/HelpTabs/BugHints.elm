module Stages.Debugging.View.HelpTabs.BugHints exposing (render)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.List
import Utils.String
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.UI.Buttons as Buttons
import Utils.UI.Text as Text


render : { requestedBugCount : Int, brokenFile : BrokenFile } -> Element Msg
render { requestedBugCount, brokenFile } =
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
        , el [ height (px 85) ] <|
            if hintVisibility.showingLineNumber then
                paragraph [ centerY ] [ text (thisBugText ++ " was introduced on line " ++ String.fromInt change.lineNumber ++ " of the original file") ]

            else
                Buttons.button []
                    { msg = ShowBugLineHint index
                    , name = "show me what line " ++ thisBugText ++ " is on"
                    }
        , el [ height (px 85) ] <|
            if hintVisibility.showingBugType then
                paragraph [ centerY, spacing 5 ]
                    (Utils.String.formatBackticks
                        (Text.codeWithAttrs
                            [ paddingXY 6 1, Border.rounded 3 ]
                        )
                        (case change.breakType of
                            CaseSwap ->
                                "changed the first letter of a word from capital to lowercase or lowercase to capital"

                            ChangeFunctionArgs ->
                                "changed the arguments of a function"

                            _ ->
                                change.changeDescription
                        )
                    )

            else
                Buttons.button []
                    { msg = ShowBugTypeHint index
                    , name = "tell me what type of bug " ++ thisOrItText ++ " is"
                    }
        ]
