module Stages.Debugging.View exposing (..)

import Element exposing (Element)
import Main.Msg exposing (Msg(..))
import Stages.Debugging.Model exposing (Page(..))
import Stages.Debugging.View.ImHavingTroublePage
import Stages.Debugging.View.StepsPage
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements exposing (Encouragements)


render :
    { bugCount : Int
    , encouragements : Encouragements
    , currentPage : Page
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, brokenFile, currentPage } =
    case currentPage of
        StepsPage ->
            Element.map DebuggingInterface <| Stages.Debugging.View.StepsPage.render bugCount brokenFile

        ImHavingTroublePage ->
            Element.map DebuggingInterface <|
                Stages.Debugging.View.ImHavingTroublePage.render
                    { bugCount = bugCount
                    , encouragements = encouragements
                    , brokenFile = brokenFile
                    }
