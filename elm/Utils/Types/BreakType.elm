module Utils.Types.BreakType exposing
    ( BreakType(..)
    , allBreakTypes
    , toChangeDescription
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


toChangeDescription : BreakType -> String
toChangeDescription breakType =
    case breakType of
        CaseSwap ->
            "somewhere in this file, I changed a word from "
                ++ "starting with a capital letter to starting with "
                ++ "a lowercase letter or vice versa."

        RemoveReturn ->
            "somewhere in this file, I removed "
                ++ "a `return` keyword from a function."

        RemoveParenthesis ->
            "somewhere in this file, I removed "
                ++ "an opening or closing parenthesis or bracket."

        ChangeFunctionArgs ->
            "somewhere in this file, I changed "
                ++ "the arguments to a function."

        RemoveDotAccess ->
            "somewhere in this file, I removed "
                ++ "one part of a dot-access chain (for example, "
                ++ "changing `thing1.thing2.thing3` to `thing1.thing2`)."
