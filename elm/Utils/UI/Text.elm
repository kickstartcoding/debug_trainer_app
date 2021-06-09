module Utils.UI.Text exposing (code, codeWithAttrs, codeAttrs)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Utils.Colors as Colors


code : String -> Element msg
code string =
    codeWithAttrs [] string


codeWithAttrs : List (Attribute msg) -> String -> Element msg
codeWithAttrs attrs string =
    el (codeAttrs ++ attrs) (text string)


codeAttrs : List (Attribute msg)
codeAttrs =
    [ Font.family
        [ Font.typeface "Monaco"
        , Font.sansSerif
        ]
    , Font.color Colors.black
    , Background.color Colors.veryLightGray
    , paddingXY 5 2
    ]
