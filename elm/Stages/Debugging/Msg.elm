module Stages.Debugging.Msg exposing (Msg(..))

import Stages.Debugging.Model exposing (Page, HelpTab)


type Msg
    = ChangePage Page
    | ChangeHelpTab HelpTab
    | SwitchToNextEncouragement
    | SwitchToNextDebuggingTip
    | SwitchToPreviousDebuggingTip
    | ShowBugLineHint Int
    | ShowBugTypeHint Int
