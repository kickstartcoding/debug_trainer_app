module Utils.Colors exposing
    ( black
    , darkened
    , gray
    , green
    , purple
    , red
    , white
    , whitened
    )

import Element exposing (Color, rgb, rgba)


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


whitened : Float -> Color
whitened amount =
    rgba 1 1 1 amount


gray : Color
gray =
    rgb 0.4 0.4 0.4


darkened : Float -> Color
darkened amount =
    rgba 0 0 0 amount
