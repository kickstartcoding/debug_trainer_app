module Utils.Types.FileType exposing (FileType(..), fromFilePath)

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
