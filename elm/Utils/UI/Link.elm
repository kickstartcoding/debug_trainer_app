module Utils.UI.Link exposing (render)

import Element exposing (..)
import Element.Font as Font
import Utils.Colors as Colors


render : List (Attribute msg) -> { url : String, label : Element msg } -> Element msg
render attrs { url, label } =
    newTabLink
        ([ Font.color Colors.kickstartCodingBlue
         , mouseOver [ Font.color Colors.veryDarkKickstartCodingBlue ]
         ]
            ++ attrs
        )
        { url = url, label = label }
