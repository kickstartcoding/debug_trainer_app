module Utils.UI.Css exposing (..)

import Element exposing (Attribute, htmlAttribute)
import Html.Attributes as HtmlAttrs


unselectable : Attribute action
unselectable =
    htmlAttribute (HtmlAttrs.style "user-select" "none")
