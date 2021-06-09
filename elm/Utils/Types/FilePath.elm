module Utils.Types.FilePath exposing
    ( FilePath
    , fromString
    , toBreakableTextElements
    , toString
    , nameOnly
    )

import Element exposing (..)
import Html


type FilePath
    = FilePath String


toString : FilePath -> String
toString (FilePath string) =
    string


toBreakableTextElements : FilePath -> List (Element msg)
toBreakableTextElements (FilePath string) =
    string
        |> String.split "/"
        |> List.intersperse "/"
        |> List.concatMap
            (\content ->
                case content of
                    "/" ->
                        [ text "/", html (Html.wbr [] []) ]

                    other ->
                        [ text other ]
            )

nameOnly : FilePath -> String
nameOnly (FilePath string )=
    string
    |> String.split "/"
    |> List.reverse
    |> List.head
    |> Maybe.withDefault string
fromString : String -> FilePath
fromString string =
    FilePath string
