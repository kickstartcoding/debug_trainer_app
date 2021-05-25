module Main.View.BrokenFile exposing (..)

import Element exposing (Element)
import Main.Msg exposing (Msg(..))
import Main.View.ImHavingTroublePage
import Main.View.StepsPage
import Stages.Debugging.Model exposing (Tab(..))
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements exposing (Encouragements)


render :
    { bugCount : Int
    , encouragements : Encouragements
    , currentTab : Tab
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, brokenFile, currentTab } =
    case currentTab of
        StepsPage ->
            Element.map DebuggingInterface <| Main.View.StepsPage.render bugCount brokenFile

        ImHavingTroublePage encouragementIsShowing ->
            Element.map DebuggingInterface <|
                Main.View.ImHavingTroublePage.render
                    { bugCount = bugCount
                    , encouragements = encouragements
                    , encouragementIsShowing = encouragementIsShowing
                    , brokenFile = brokenFile
                    }
