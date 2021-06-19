module ParserTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Parser exposing (DeadEnd)
import Parsers.Generic.Parser as GenericParser
import Parsers.Generic.Segment exposing (BreakStatus(..), SegmentType(..))
import Test exposing (..)
import TestHelp as TestHelp
import Utils.Types.FileType exposing (FileType(..))


suite : Test
suite =
    describe "Parsers.Generic.Parser.run"
        [ test "detects words" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "   abc^&*"
                    [ { content = "   ", offset = 0, segmentType = Whitespace }
                    , { content = "abc", offset = 3, segmentType = Word BreakNotAppliedYet }
                    , { content = "^", offset = 6, segmentType = Other }
                    , { content = "&", offset = 7, segmentType = Other }
                    , { content = "*", offset = 8, segmentType = Other }
                    ]
        , test "detects return statements" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "return "
                    [ { content = "return ", offset = 0, segmentType = ReturnStatement BreakNotAppliedYet }
                    ]
        , test "ignores the word return if no whitespace between it and the next word" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    " return"
                    [ { content = " ", offset = 0, segmentType = Whitespace }
                    , { content = "return", offset = 1, segmentType = Word BreakNotAppliedYet }
                    ]
        , test "detects parentheses at the start of a line" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "\n ) abc"
                    [ { content = "\n ) ", offset = 0, segmentType = ParenthesisOrBracket BreakNotAppliedYet }
                    , { content = "abc", offset = 4, segmentType = Word BreakNotAppliedYet }
                    ]
        , test "detects parentheses at the end of a line" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "abc ) \n"
                    [ { content = "abc", offset = 0, segmentType = Word BreakNotAppliedYet }
                    , { content = " ) \n", offset = 3, segmentType = ParenthesisOrBracket BreakNotAppliedYet }
                    ]
        , test "detects functions" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "function hello(arg1, arg2)"
                    [ { content = "function hello(arg1, arg2)"
                      , offset = 0
                      , segmentType =
                            FunctionDeclaration
                                { declarationWord = "function"
                                , name = "hello"
                                , arguments = [ "arg1", "arg2" ]
                                }
                                BreakNotAppliedYet
                      }
                    ]
        , test "detects brackets at the start of a line" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "\n{"
                    [ { content = "\n{", offset = 0, segmentType = ParenthesisOrBracket BreakNotAppliedYet } ]
        , test "detects brackets at the start of a line with multiple preceing newlines" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "\n\n\n{"
                    [ { content = "\n", offset = 0, segmentType = Whitespace }
                    , { content = "\n", offset = 1, segmentType = Whitespace }
                    , { content = "\n{", offset = 2, segmentType = ParenthesisOrBracket BreakNotAppliedYet }
                    ]
        , test "detects brackets at the end of a line" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "}\n"
                    [ { content = "}\n", offset = 0, segmentType = ParenthesisOrBracket BreakNotAppliedYet } ]
        , test "detects dot-access" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "thing1.thing2"
                    [ { content = "thing1.thing2", offset = 0, segmentType = DotAccess BreakNotAppliedYet } ]
        , test "detects triple dot-access" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Unknown)
                    "thing1.thing2.thing3"
                    [ { content = "thing1.thing2.thing3", offset = 0, segmentType = DotAccess BreakNotAppliedYet } ]
        , test "detects javascript comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run JavaScript)
                    "// comment"
                    [ { content = "// comment", offset = 0, segmentType = Comment } ]
        , test "detects javascript multiline comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run JavaScript)
                    "/* comment\ncomment */"
                    [ { content = "/* comment\ncomment */", offset = 0, segmentType = Comment } ]
        , test "detects python comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Python)
                    "# comment"
                    [ { content = "# comment", offset = 0, segmentType = Comment } ]
        , test "detects python multiline comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Python)
                    "''' comment\ncomment '''"
                    [ { content = "''' comment\ncomment '''", offset = 0, segmentType = Comment } ]
        , test "detects ruby comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Ruby)
                    "# comment"
                    [ { content = "# comment", offset = 0, segmentType = Comment } ]
        , test "detects ruby multiline comments" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Ruby)
                    "=begin comment\ncomment =end"
                    [ { content = "=begin comment\ncomment =end", offset = 0, segmentType = Comment } ]
        , test "detects double-quoted strings" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Ruby)
                    "\"word word word\""
                    [ { content = "\"word word word\"", offset = 0, segmentType = String } ]
        , test "detects single-quoted strings" <|
            \_ ->
                TestHelp.expectResult (GenericParser.run Ruby)
                    "'word word word'"
                    [ { content = "'word word word'", offset = 0, segmentType = String } ]
        ]
