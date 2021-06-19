module BreakFileTest exposing (..)

import Fuzz exposing (int, list)
import Parsers.Generic.Segment exposing (BreakStatus(..), SegmentType(..))
import Test exposing (..)
import TestHelp
    exposing
        ( expectBreakResult
        , expectBreakResultWithExt
        , expectBreakToOutputOneOf
        , expectBreakWithExtToOutputOneOf
        , expectMultiBreakResult
        , expectMultiBreakToOutputOneOf
        )


suite : Test
suite =
    describe "BreakFile"
        [ describe "comment ignoring functionality"
            [ describe "javascript"
                [ fuzz (list int) "does not break words in js comments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "js"
                            , randomNumbers = randomNumbers
                            , input = "// comment"
                            , output = "// comment"
                            }
                , fuzz (list int) "breaks words in python comments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "js"
                            , randomNumbers = randomNumbers
                            , input = "# word"
                            , output = "# Word"
                            }
                ]
            , describe "python"
                [ fuzz (list int) "does not break words in python comments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "py"
                            , randomNumbers = randomNumbers
                            , input = "# comment"
                            , output = "# comment"
                            }
                , fuzz (list int) "breaks words in js comments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "py"
                            , randomNumbers = randomNumbers
                            , input = "// word"
                            , output = "// Word"
                            }
                ]
            ]
        , describe "string ignoring functionality"
            [ fuzz (list int) "ignores double-quoted strings" <|
                \randomNumbers ->
                    expectBreakResult
                        { randomNumbers = randomNumbers
                        , input = "word \"word word word\""
                        , output = "Word \"word word word\""
                        }
            , fuzz (list int) "ignores single-quoted strings" <|
                \randomNumbers ->
                    expectBreakResult
                        { randomNumbers = randomNumbers
                        , input = "word 'word word word'"
                        , output = "Word 'word word word'"
                        }
            ]
        , describe "multi-breaking"
            [ fuzz (list int) "causes specified number of errors" <|
                \randomNumbers ->
                    expectMultiBreakToOutputOneOf
                        { randomNumbers = randomNumbers
                        , input = "hey ho hi"
                        , outputPossibilities = [ "hey Ho Hi", "Hey ho Hi", "Hey Ho hi" ]
                        , breakCount = 2
                        }
            , fuzz (list int) "gives up on more errors if no possible errors left" <|
                \randomNumbers ->
                    expectMultiBreakResult
                        { randomNumbers = randomNumbers
                        , input = "hey ho hi"
                        , output = "Hey Ho Hi"
                        , breakCount = 9999
                        }
            ]
        ]
