module Main.View.BrokenFile exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Main.Model exposing (BrokenFile, Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.FilePath as FilePath exposing (FilePath)


render : Int -> BrokenFile -> Element Msg
render bugCount { changes, path } =
    let
        changeCount =
            List.length changes
    in
    column
        [ Font.color (rgb 0 0 0)
        , Font.size 25
        , spacing 30
        , centerX
        , centerY
        ]
        [ paragraph []
            [ text
                ("I broke "
                    ++ FilePath.toString path
                    ++ " "
                    ++ (changeCount
                            |> String.fromInt
                       )
                    ++ " "
                    ++ Pluralize.singularOrPlural changeCount "time"
                    ++ "! Can you figure out where?"
                )
            ]
        ]
