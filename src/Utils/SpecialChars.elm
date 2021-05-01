module Utils.SpecialChars exposing (nonbreakingSpaces)

import String exposing (fromList)


nonbreakingSpace : Char
nonbreakingSpace =
    '\u{00A0}'


nonbreakingSpaces : Int -> String
nonbreakingSpaces numberOfSpaces =
    List.repeat numberOfSpaces nonbreakingSpace
        |> fromList
