module Utils.UI.Attributes exposing
    ( ariaDescribedBy
    , ariaKeyShortcut
    , dialogRole
    , title
    )

import Accessibility.Aria as Aria
import Accessibility.Role
import Element exposing (..)
import Html.Attributes as HtmlAttrs


title : String -> Attribute action
title string =
    htmlAttribute (HtmlAttrs.title string)


dialogRole : Attribute action
dialogRole =
    htmlAttribute Accessibility.Role.dialog


ariaDescribedBy : String -> Attribute action
ariaDescribedBy string =
    htmlAttribute (Aria.describedBy [ string ])


ariaKeyShortcut : String -> Attribute action
ariaKeyShortcut shortcut =
    htmlAttribute (Aria.keyShortcuts [ shortcut ])
