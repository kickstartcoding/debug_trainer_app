module Parsers.Utils.Code exposing
    ( anythingButCommasOrParens
    , doubleQuoteString
    , otherCharacter
    , parenthesisOrBracket
    , returnStatement
    , singleQuoteString
    , string
    , word
    )

import Parser exposing (..)
import Parsers.Utils.Repeat as Repeat
import Parsers.Utils.Whitespace as Whitespace


returnStatement : Parser ()
returnStatement =
    backtrackable <|
        succeed ()
            |. token "return"
            |. Whitespace.one


parenthesisOrBracket : Parser ()
parenthesisOrBracket =
    oneOf
        [ token "{"
        , token "}"
        , token "("
        , token ")"
        , token "["
        , token "]"
        ]


anythingButCommasOrParens : Parser String
anythingButCommasOrParens =
    getChompedString <|
        Repeat.oneOrMore
            (chompIf
                (\char ->
                    char
                        /= ','
                        && char
                        /= '('
                        && char
                        /= ')'
                )
            )


word : Parser String
word =
    getChompedString <| Repeat.oneOrMore wordCharacter


wordCharacter : Parser ()
wordCharacter =
    chompIf isWordCharacter


isWordCharacter : Char -> Bool
isWordCharacter char =
    Char.isAlphaNum char || List.member char [ '_' ]


otherCharacter : Parser ()
otherCharacter =
    chompIf isOtherCharacter


isOtherCharacter : Char -> Bool
isOtherCharacter char =
    (char /= '"')
        && (char /= '\'')
        && not (isWordCharacter char)
        && not (Whitespace.isValidWhiteSpace char)


string : Parser ()
string =
    oneOf
        [ doubleQuoteString
        , singleQuoteString
        ]


doubleQuoteString : Parser ()
doubleQuoteString =
    succeed ()
        |. multiComment "\"" "\"" NotNestable
        |. token "\""



-- succeed ()
--     |. token "\""
--     |. Repeat.zeroOrMore
--         (oneOf
--             [ token "\\\""
--             , chompIf (\char -> char /= '"')
--             ]
--         )
--     |. token "\""


singleQuoteString : Parser ()
singleQuoteString =
    succeed ()
        |. multiComment "'" "'" NotNestable
        |. token "'"
