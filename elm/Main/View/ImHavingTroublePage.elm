module Main.View.ImHavingTroublePage exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Main.Model exposing (BrokenFile, DebuggingInterfaceTab, Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.FilePath as FilePath exposing (FilePath)


render : Int -> BrokenFile -> Element Msg
render bugCount { changes, path } =
    none
