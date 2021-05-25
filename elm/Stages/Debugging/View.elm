module Stages.Debugging.View exposing (..)

import Element exposing (Element)
import Main.Msg exposing (Msg(..))
import Stages.Debugging.Model exposing (Tab(..))
import Stages.Debugging.View.ImHavingTroublePage
import Stages.Debugging.View.StepsPage
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
            Element.map DebuggingInterface <| Stages.Debugging.View.StepsPage.render bugCount brokenFile

        ImHavingTroublePage encouragementIsShowing ->
            Element.map DebuggingInterface <|
                Stages.Debugging.View.ImHavingTroublePage.render
                    { bugCount = bugCount
                    , encouragements = encouragements
                    , encouragementIsShowing = encouragementIsShowing
                    , brokenFile = brokenFile
                    }
