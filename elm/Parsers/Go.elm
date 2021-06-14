module Parsers.Go exposing (blockComment, comment, functionDeclaration)

import Parser exposing (..)
import Parsers.Utils.Code as Code
import Parsers.Utils.Repeat as Repeat
import Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration)


functionDeclaration : Parser NamedFunctionDeclaration
functionDeclaration =
    backtrackable <|
        succeed NamedFunctionDeclaration
            |= (getChompedString <| token "func")
            |. token " "
            |= (getChompedString <| Code.word)
            |. token "("
            |= Repeat.zeroOrMoreWithSeparator
                Repeat.commaSeparator
                Code.anythingButCommasOrParens
            |. token ")"


comment : Parser ()
comment =
    lineComment "//"


blockComment : Parser ()
blockComment =
    succeed ()
        |. multiComment "/*" "*/" Nestable
        |. token "*/"
