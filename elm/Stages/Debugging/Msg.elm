module Stages.Debugging.Msg exposing (Msg(..))

import Stages.Debugging.Model exposing (Tab)

type Msg
    = ChangeTab Tab
    | ShowBugLineHint Int
    | ShowBugTypeHint Int
    | SaySomethingEncouraging