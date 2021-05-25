module Main.View.BrokenFile exposing (..)

import Element exposing (Element)
import Main.Model
    exposing
        ( BrokenFile
        , DebuggingInterfaceTab(..)
        , Encouragements
        , Model
        )
import Main.Msg exposing (Msg(..))
import Main.View.ImHavingTroublePage
import Main.View.StepsPage


render :
    { bugCount : Int
    , encouragements : Encouragements
    , currentTab : DebuggingInterfaceTab
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, brokenFile, currentTab } =
    case currentTab of
        StepsPage ->
            Main.View.StepsPage.render bugCount brokenFile

        ImHavingTroublePage encouragementIsShowing ->
            Main.View.ImHavingTroublePage.render
                { bugCount = bugCount
                , encouragements = encouragements
                , encouragementIsShowing = encouragementIsShowing
                , brokenFile = brokenFile
                }
