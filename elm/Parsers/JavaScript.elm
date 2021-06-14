module Parsers.JavaScript exposing
    ( blockComment
    , comment
    , fatArrowFunctionDeclaration
    , functionDeclaration
    )

import Parser exposing (..)
import Parsers.Utils.Code as Code
import Parsers.Utils.Repeat as Repeat
import Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration)


functionDeclaration : Parser NamedFunctionDeclaration
functionDeclaration =
    backtrackable <|
        succeed NamedFunctionDeclaration
            |= (getChompedString <| token "function")
            |. token " "
            |= (getChompedString <| Code.word)
            |. token "("
            |= Repeat.zeroOrMoreWithSeparator
                Repeat.commaSeparator
                Code.word
            |. token ")"


fatArrowFunctionDeclaration : Parser NamedFunctionDeclaration
fatArrowFunctionDeclaration =
    backtrackable <|
        succeed NamedFunctionDeclaration
            |= (getChompedString <| oneOf [ token "const", token "let", token "var" ])
            |. token " "
            |= (getChompedString <| Code.word)
            |. token " = "
            |. token "("
            |= Repeat.zeroOrMoreWithSeparator
                Repeat.commaSeparator
                Code.word
            |. token ") => "


comment : Parser ()
comment =
    lineComment "//"


blockComment : Parser ()
blockComment =
    succeed ()
        |. multiComment "/*" "*/" NotNestable
        |. token "*/"
