module Utils.UI.Attributes exposing (title)

import Element exposing (..)
import Html.Attributes as HtmlAttrs


title : String -> Attribute action
title string =
    htmlAttribute (HtmlAttrs.title string)
