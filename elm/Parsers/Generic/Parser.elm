module Parsers.Generic.Parser exposing (run)

import Parser exposing (..)
import Parsers.Elixir as Elixir
import Parsers.Elm as Elm
import Parsers.Generic.Segment exposing (BreakStatus(..), Segment, SegmentType(..))
import Parsers.JavaScript as JavaScript
import Parsers.Python as Python
import Parsers.Ruby as Ruby
import Parsers.Rust as Rust
import Parsers.Go as Go
import Parsers.UnknownLanguage as UnknownLanguage
import Parsers.Utils
import Parsers.Utils.Code as Code
import Parsers.Utils.Repeat as Repeat
import Parsers.Utils.Whitespace as Whitespace
import Utils.Types.FileType exposing (FileType(..))
import Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration)


run : FileType -> String -> Result (List DeadEnd) (List Segment)
run fileType string =
    Parser.run (segments fileType) string


segments : FileType -> Parser (List Segment)
segments fileType =
    succeed identity
        |= Repeat.oneOrMore (segment fileType)
        |. end


segment : FileType -> Parser Segment
segment fileType =
    getOffset
        |> andThen
            (\offset ->
                oneOf
                    ((case fileType of
                        JavaScript ->
                            [ JavaScript.comment
                                |> mapStringToSegment offset Comment
                            , JavaScript.blockComment
                                |> mapStringToSegment offset Comment
                            , JavaScript.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            , JavaScript.fatArrowFunctionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Python ->
                            [ Python.comment
                                |> mapStringToSegment offset Comment
                            , Python.blockComment
                                |> mapStringToSegment offset Comment
                            , Python.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Ruby ->
                            [ Ruby.comment
                                |> mapStringToSegment offset Comment
                            , Ruby.blockComment
                                |> mapStringToSegment offset Comment
                            , Ruby.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Elm ->
                            [ Elm.comment
                                |> mapStringToSegment offset Comment
                            , Elm.blockComment
                                |> mapStringToSegment offset Comment
                            , Elm.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Elixir ->
                            [ Elixir.comment
                                |> mapStringToSegment offset Comment
                            , Elixir.blockComment
                                |> mapStringToSegment offset Comment
                            , Elixir.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Rust ->
                            [ Rust.comment
                                |> mapStringToSegment offset Comment
                            , Rust.blockComment
                                |> mapStringToSegment offset Comment
                            , Rust.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Go ->
                            [ Go.comment
                                |> mapStringToSegment offset Comment
                            , Go.blockComment
                                |> mapStringToSegment offset Comment
                            , Go.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]

                        Unknown ->
                            [ UnknownLanguage.functionDeclaration
                                |> mapFunctionDeclarationToSegment offset
                            ]
                     )
                        ++ [ Code.returnStatement
                                |> mapStringToSegment offset (ReturnStatement BreakNotAppliedYet)
                           , parenthesisOrBracketAtStartOrEndOfLine
                                |> mapStringToSegment offset (ParenthesisOrBracket BreakNotAppliedYet)
                           , dotAccess
                                |> mapStringToSegment offset (DotAccess BreakNotAppliedYet)
                           , Code.word
                                |> mapStringToSegment offset (Word BreakNotAppliedYet)
                           , Code.string
                                |> mapStringToSegment offset String
                           , Repeat.oneOrMore (chompIf Whitespace.isNonNewlineWhiteSpace)
                                |> mapStringToSegment offset Whitespace
                           , chompIf (\char -> char == '\n')
                                |> mapStringToSegment offset Whitespace
                           , Code.otherCharacter
                                |> mapStringToSegment offset Other
                           ]
                    )
            )


mapStringToSegment : Int -> SegmentType -> Parser data -> Parser Segment
mapStringToSegment offset segmentType parser =
    parser
        |> getChompedString
        |> Parser.map
            (\content ->
                Segment offset content segmentType
            )


mapFunctionDeclarationToSegment : Int -> Parser NamedFunctionDeclaration -> Parser Segment
mapFunctionDeclarationToSegment offset parser =
    Parsers.Utils.contentAndResult parser
        |> Parser.map
            (\( content, data ) ->
                Segment offset
                    content
                    (FunctionDeclaration data BreakNotAppliedYet)
            )


dotAccess : Parser ()
dotAccess =
    succeed ()
        |. (backtrackable <|
                succeed ()
                    |. Code.word
                    |. Repeat.oneOrMore
                        (succeed ()
                            |. token "."
                            |. Code.word
                        )
           )


parenthesisOrBracketAtStartOrEndOfLine : Parser ()
parenthesisOrBracketAtStartOrEndOfLine =
    succeed ()
        |. oneOf
            [ backtrackable <|
                succeed ()
                    |. token "\n"
                    |. Repeat.zeroOrMore (token " ")
                    |. Code.parenthesisOrBracket
                    |. Repeat.zeroOrMore (token " ")
            , backtrackable <|
                succeed ()
                    |. Repeat.zeroOrMore (token " ")
                    |. Code.parenthesisOrBracket
                    |. Repeat.zeroOrMore (token " ")
                    |. token "\n"
            ]
