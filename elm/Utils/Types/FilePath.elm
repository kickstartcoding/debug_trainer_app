module Utils.Types.FilePath exposing
    ( FilePath
    , fromString
    , nameOnly
    , toString
    )

import Element exposing (..)


type FilePath
    = FilePath String


toString : FilePath -> String
toString (FilePath string) =
    string


nameOnly : FilePath -> String
nameOnly (FilePath string) =
    string
        |> String.split "/"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault string


fromString : String -> FilePath
fromString string =
    FilePath string
