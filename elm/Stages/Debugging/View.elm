module Stages.Debugging.View exposing (..)

import Element exposing (Element)
import Stages.Debugging.Model exposing (HelpTab, Page(..))
import Stages.Debugging.Msg exposing (Msg(..))
import Stages.Debugging.View.HelpPage
import Stages.Debugging.View.IDontSeeAnyErrorsPage
import Stages.Debugging.View.StepsPage
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements exposing (Encouragements)


render :
    { bugCount : Int
    , encouragements : Encouragements
    , currentPage : Page
    , currentHelpTab : HelpTab
    , currentDebuggingTip : Int
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, currentDebuggingTip, brokenFile, currentPage, currentHelpTab } =
    case currentPage of
        StepsPage ->
            Stages.Debugging.View.StepsPage.render bugCount brokenFile

        HelpPage ->
            Stages.Debugging.View.HelpPage.render
                { bugCount = bugCount
                , encouragements = encouragements
                , currentDebuggingTip = currentDebuggingTip
                , brokenFile = brokenFile
                , currentHelpTab = currentHelpTab
                }

        IDontSeeAnyErrorsPage ->
            Stages.Debugging.View.IDontSeeAnyErrorsPage.render brokenFile
