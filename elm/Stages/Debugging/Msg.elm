module Stages.Debugging.Msg exposing (Msg(..))

import Stages.Debugging.Model exposing (HelpTab, Page)


type Msg
    = ChangePage Page
    | ChangeHelpTab HelpTab
    | SwitchToNextEncouragement
    | SwitchToNextDebuggingTip
    | SwitchToPreviousDebuggingTip
    | ShowBugLineHint Int
    | ShowBugTypeHint Int
    | ShowTheAnswer
