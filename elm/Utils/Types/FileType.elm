module Utils.Types.FileType exposing
    ( FileType(..)
    , fromFilePath
    , toPrintFunctionName
    , toString
    )

import String
import Utils.Types.FilePath as FilePath exposing (FilePath)


type FileType
    = Python
    | JavaScript
    | Ruby
    | Elm
    | Elixir
    | Rust
    | Go
    | Unknown


toString : FileType -> String
toString fileType =
    case fileType of
        Python ->
            "Python"

        JavaScript ->
            "JavaScript"

        Ruby ->
            "Ruby"

        Elm ->
            "Elm"

        Elixir ->
            "Elixir"

        Rust ->
            "Rust"

        Go ->
            "Go"

        Unknown ->
            "unknown"


toPrintFunctionName : FileType -> String
toPrintFunctionName fileType =
    case fileType of
        Python ->
            "print"

        JavaScript ->
            "console.log"

        Ruby ->
            "print"

        Elm ->
            "Debug.log"

        Elixir ->
            "IO.print"

        Rust ->
            "print!"

        Go ->
            "print"

        Unknown ->
            "print"


fromFilePath : FilePath -> FileType
fromFilePath filepath =
    let
        filepathString =
            FilePath.toString filepath
    in
    if String.endsWith ".js" filepathString then
        JavaScript

    else if String.endsWith ".ts" filepathString then
        JavaScript

    else if String.endsWith ".py" filepathString then
        Python

    else if String.endsWith ".rb" filepathString then
        Ruby

    else if String.endsWith ".elm" filepathString then
        Elm

    else if String.endsWith ".ex" filepathString then
        Elixir

    else if String.endsWith ".exs" filepathString then
        Elixir

    else if String.endsWith ".rs" filepathString then
        Rust

    else if String.endsWith ".go" filepathString then
        Go

    else
        Unknown
