module Main.View.BrokenFile exposing (..)

import Element exposing (Element)
import Main.Model exposing (BrokenFile, DebuggingInterfaceTab(..), Model)
import Main.Msg exposing (Msg(..))
import Main.View.ImHavingTroublePage
import Main.View.StepsPage


render : Int -> BrokenFile -> DebuggingInterfaceTab -> Element Msg
render bugCount brokenFile interface =
    case interface of
        StepsPage ->
            Main.View.StepsPage.render bugCount brokenFile

        ImHavingTroublePage ->
            Main.View.ImHavingTroublePage.render bugCount brokenFile
