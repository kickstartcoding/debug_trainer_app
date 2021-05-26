module Utils.UI.Buttons exposing (back)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Utils.Colors as Colors


back : { name : String, msg : msg } -> Element msg
back { name, msg } =
    Input.button
        [ Background.color Colors.purple
        , Font.color Colors.white
        , Font.center
        , width (px 250)
        , paddingXY 35 20
        , Border.rounded 5
        ]
        { onPress = Just msg
        , label = row [] [ el [ Font.bold ] (text "‹"), text (" " ++ name) ]
        }
