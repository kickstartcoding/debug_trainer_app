module Utils.UI.Buttons exposing (back, button)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Utils.Colors as Colors


button : List (Attribute msg) -> { name : String, msg : msg } -> Element msg
button attrs { name, msg } =
    buttonTemplate
        { label = paragraph [] [ text name ]
        , attrs = attrs
        , msg = Just msg
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
         , Border.width 2
         , Border.color Colors.white
         , width (minimum 250 shrink)
         , paddingXY 37 22
         , Border.rounded 8
         , htmlAttribute (HtmlAttrs.style "cursor" "pointer")
         , alpha 1
         , mouseOver [ Border.color Colors.transparent ]
         ]
            ++ attrs
        )
        { onPress = msg
        , label = label
        }
