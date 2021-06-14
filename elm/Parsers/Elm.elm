module Parsers.Elm exposing (blockComment, comment, functionDeclaration)

import Parser exposing (..)
import Parsers.Utils.Code as Code
import Parsers.Utils.Repeat as Repeat
import Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration)


functionDeclaration : Parser NamedFunctionDeclaration
functionDeclaration =
    backtrackable <|
        succeed (NamedFunctionDeclaration "")
            |= (getChompedString <| Code.word)
            |. token " "
            |= Repeat.oneOrMoreWithSeparator
                (token " ")
                Code.word
            |. token " ="


comment : Parser ()
comment =
    lineComment "--"


blockComment : Parser ()
blockComment =
    succeed ()
        |. multiComment "{-" "-}" NotNestable
        |. token "-}"
