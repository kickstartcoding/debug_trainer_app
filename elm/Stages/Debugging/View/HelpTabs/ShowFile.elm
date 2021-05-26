module Stages.Debugging.View.HelpTabs.ShowFile exposing (..)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (monospace)
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FilePath as FilePath
import Utils.Types.FileType as FileType exposing (FileType)


render : BrokenFile -> Element Msg
render { originalContent, updatedContent, path } =
    column
        [ spacing 30
        , height fill
        , width fill
        , paddingXY 40 40
        , scrollbars
        ]
    <|
        [ renderFile (FilePath.toString path ++ " (original file)") originalContent
        , renderFile (FilePath.toString path ++ " (file with bug(s) added)") updatedContent
        ]


renderFile : String -> String -> Element Msg
renderFile name content =
    column [ spacing 10, height fill, width fill ]
        [ paragraph [ Font.center, Font.size 30 ] [ text name ]
        , el
            [ width fill
            , height fill
            , Background.color Colors.veryLightGray
            , paddingXY 20 10
            , Border.rounded 5
            , Font.family [ Font.monospace ]
            ]
            (text content)
        ]
