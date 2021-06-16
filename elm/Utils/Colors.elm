module Utils.Colors exposing
    ( black
    , darkGray
    , darkKickstartCodingBlue
    , darkened
    , green
    , kickstartCodingBlue
    , lightGray
    , purple
    , red
    , transparent
    , veryLightGray
    , white
    )

import Element exposing (Color, rgb, rgb255, rgba)


kickstartCodingBlue : Color
kickstartCodingBlue =
    rgb255 25 181 254


darkKickstartCodingBlue : Color
darkKickstartCodingBlue =
    rgb255 20 140 204


purple : Color
purple =
    rgb 0.45 0 0.7


green : Color
green =
    rgb 0 0.7 0


red : Color
red =
    rgb 0.8 0 0


black : Color
black =
    rgb 0 0 0


white : Color
white =
    rgb 1 1 1


darkGray : Color
darkGray =
    rgb 0.3 0.3 0.3


lightGray : Color
lightGray =
    rgb 0.8 0.8 0.8


veryLightGray : Color
veryLightGray =
    rgb 0.9 0.9 0.9


darkened : Float -> Color
darkened amount =
    rgba 0 0 0 amount


transparent : Color
transparent =
    rgba 0 0 0 0
