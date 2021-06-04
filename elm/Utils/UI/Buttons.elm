module Utils.UI.Buttons exposing (back, button)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Utils.Colors as Colors


button : List (Attribute msg) -> { name : String, msg : msg } -> Element msg
button attrs { name, msg } =
    buttonTemplate
        { label = text name
        , attrs = attrs
        , msg = msg
        }


back : { name : String, msg : msg } -> Element msg
back { name, msg } =
    buttonTemplate
        { label = row [] [ el [ Font.bold ] (text "‹"), text (" " ++ name) ]
        , attrs = []
        , msg = msg
        }


buttonTemplate : { label : Element msg, attrs : List (Attribute msg), msg : msg } -> Element msg
buttonTemplate { label, attrs, msg } =
    Input.button
        ([ Background.color Colors.purple
         , Font.color Colors.white
         , Font.center
         , width (px 250)
         , paddingXY 35 20
         , Border.rounded 5
         ]
            ++ attrs
        )
        { onPress = Just msg
        , label = label
        }
