module Main.View.BrokenFile exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Main.Model exposing (BrokenFile, Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.SpecialChars exposing (nonbreakingSpaces)


render : Int -> BrokenFile -> Element Msg
render bugCount brokenFile =
    column
        [ Font.color (rgb 0 0 0)
        , Font.size 25
        , spacing 30
        , centerX
        , centerY
        ]
        []
