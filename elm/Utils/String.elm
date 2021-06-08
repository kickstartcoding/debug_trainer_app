module Utils.String exposing
    ( isAllCaps
    , isMoreThanOneCharacter
    , isTitleCase
    , toFormattedElements
    , toggleTitleCase
    )

import Element exposing (..)
import Element.Border as Border
import String.Extra as StrEx
import Utils.UI.Text as Text


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


toFormattedElements : String -> List (Element msg)
toFormattedElements description =
    description
        |> String.split "`"
        |> List.indexedMap
            (\i string ->
                if isEven i then
                    text string

                else
                    Text.codeWithAttrs [ paddingXY 6 1, Border.rounded 3 ] string
            )


isEven : Int -> Bool
isEven integer =
    modBy 2 integer == 0
