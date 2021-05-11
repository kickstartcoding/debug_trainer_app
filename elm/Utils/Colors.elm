module Utils.Colors exposing (black, darkened, purple, white, whitened)

import Element exposing (Color, rgb, rgba)


purple : Color
purple =
    rgb 0.45 0 0.7


black : Color
black =
    rgb 0 0 0


white : Color
white =
    rgb 1 1 1


whitened : Float -> Color
whitened amount =
    rgba 1 1 1 amount


darkened : Float -> Color
darkened amount =
    rgba 0 0 0 amount
