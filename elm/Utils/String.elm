module Utils.String exposing
    ( isAllCaps
    , isMoreThanOneCharacter
    , isTitleCase
    , toggleTitleCase
    )

import String.Extra as StrEx


toggleTitleCase : String -> String
toggleTitleCase string =
    if isTitleCase string then
        StrEx.decapitalize string

    else
        StrEx.toTitleCase string


isTitleCase : String -> Bool
isTitleCase string =
    StrEx.toTitleCase string == string


isMoreThanOneCharacter : String -> Bool
isMoreThanOneCharacter string =
    String.length string > 1


isAllCaps : String -> Bool
isAllCaps string =
    String.toUpper string == string
