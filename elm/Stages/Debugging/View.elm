module Stages.Debugging.View exposing (..)

import Element exposing (Element)
import Main.Msg exposing (Msg(..))
import Stages.Debugging.Model exposing (HelpTab, Page(..))
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
    , answerIsShowing : Bool
    , brokenFile : BrokenFile
    }
    -> Element Msg
render { bugCount, encouragements, currentDebuggingTip, answerIsShowing, brokenFile, currentPage, currentHelpTab } =
    case currentPage of
        StepsPage ->
            Element.map DebuggingInterface <| Stages.Debugging.View.StepsPage.render bugCount brokenFile

        HelpPage ->
            Element.map DebuggingInterface <|
                Stages.Debugging.View.HelpPage.render
                    { bugCount = bugCount
                    , encouragements = encouragements
                    , currentDebuggingTip = currentDebuggingTip
                    , answerIsShowing = answerIsShowing
                    , brokenFile = brokenFile
                    , currentHelpTab = currentHelpTab
                    }

        IDontSeeAnyErrorsPage ->
            Element.map DebuggingInterface <|
                Stages.Debugging.View.IDontSeeAnyErrorsPage.render brokenFile
