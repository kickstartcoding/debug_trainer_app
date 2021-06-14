module Utils.UI.Link exposing (render)

import Element exposing (..)
import Element.Font as Font
import Utils.Colors as Colors


render : { url : String, label : Element msg } -> Element msg
render { url, label } =
    link
        [ Font.color Colors.purple
        , Font.underline
        , mouseOver [ Font.color Colors.darkPurple ]
        ]
        { url = url, label = label }
