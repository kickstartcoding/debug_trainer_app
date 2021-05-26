module Stages.Debugging.View.HelpTabs.DebuggingTips exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FileType as FileType exposing (FileType)


render : { bugCount : Int, encouragements : Encouragements, brokenFile : BrokenFile } -> Element Msg
render { bugCount, encouragements, brokenFile } =
    let
        fileType =
            brokenFile.path |> FileType.fromFilePath
    in
    column [ width fill, height fill, spacing 30 ]
        [ column [ spacing 20, Background.color Colors.lightGray, Border.rounded 5, paddingXY 20 20 ]
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
