module Utils.UI.Link exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Utils.Colors as Colors


render { url, label } =
    link
        [ Font.color Colors.purple
        , Font.underline
        , mouseOver [ Font.color Colors.darkPurple ]
        ]
        { url = url, label = label }
