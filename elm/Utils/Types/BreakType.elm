module Utils.Types.BreakType exposing
    ( BreakType(..)
    , allBreakTypes
    )


type BreakType
    = CaseSwap
    | RemoveReturn
    | RemoveParenthesis
    | ChangeFunctionArgs
    | RemoveDotAccess


allBreakTypes : List BreakType
allBreakTypes =
    [ CaseSwap
    , RemoveReturn
    , RemoveParenthesis
    , ChangeFunctionArgs
    , RemoveDotAccess
    ]
