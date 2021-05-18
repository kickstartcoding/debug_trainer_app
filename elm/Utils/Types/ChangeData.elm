module Utils.Types.ChangeData exposing (ChangeData)

import Utils.Types.BreakType exposing (BreakType)


type alias ChangeData =
    { lineNumber : Int
    , breakType : BreakType
    , changeDescription : String
    }
