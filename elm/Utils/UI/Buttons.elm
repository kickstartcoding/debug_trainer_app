module Utils.UI.Buttons exposing (back, button, disableableButton)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Utils.Colors as Colors


button : List (Attribute msg) -> { name : String, msg : msg } -> Element msg
button attrs { name, msg } =
    buttonTemplate
        { label = paragraph [] [ text name ]
        , attrs = attrs
        , msg = Just msg
        }


disableableButton : List (Attribute msg) -> { name : String, maybeMsg : Maybe msg } -> Element msg
disableableButton attrs { name, maybeMsg } =
    buttonTemplate
        { label = paragraph [] [ text name ]
        , attrs = attrs
        , msg = maybeMsg
        }


back : { name : String, msg : msg } -> Element msg
back { name, msg } =
    buttonTemplate
        { label = row [] [ el [ Font.bold ] (text "‹"), text (" " ++ name) ]
        , attrs = []
        , msg = Just msg
        }


buttonTemplate : { label : Element msg, attrs : List (Attribute msg), msg : Maybe msg } -> Element msg
buttonTemplate { label, attrs, msg } =
    Input.button
        ([ Background.color Colors.purple
         , Font.color Colors.white
         , Font.center
         , width (minimum 250 shrink)
         , paddingXY 35 20
         , Border.rounded 5
         ]
            ++ attrs
        )
        { onPress = msg
        , label = label
        }
