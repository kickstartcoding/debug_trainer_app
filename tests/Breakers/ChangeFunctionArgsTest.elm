module Breakers.ChangeFunctionArgsTest exposing (..)

import Fuzz exposing (int, list)
import Parsers.Generic.Segment exposing (BreakStatus(..), SegmentType(..))
import Test exposing (..)
import TestHelp as TestHelp
    exposing
        ( expectBreakResult
        , expectBreakResultWithExt
        , expectBreakToOutputOneOf
        , expectBreakWithExtToOutputOneOf
        )


suite : Test
suite =
    describe "ChangeFunctionArgs"
        [ describe "python"
            [ fuzz (list int) "one argument" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "py"
                        , input = " def name(arg1):"
                        , output = " def name():"
                        , randomNumbers = randomNumbers
                        }
            , fuzz (list int) "two arguments" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "py"
                        , input = " def name(arg1, arg2):"
                        , output = " def name(arg2, arg1):"
                        , randomNumbers = randomNumbers
                        }
            ]
        , describe "javascript"
            [ fuzz (list int) "one argument standard function syntax" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "js"
                        , input = " function name(arg1){"
                        , output = " function name(){"
                        , randomNumbers = randomNumbers
                        }
            , fuzz (list int) "two arguments standard function syntax" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "js"
                        , input = " function name(arg1, arg2){"
                        , output = " function name(arg2, arg1){"
                        , randomNumbers = randomNumbers
                        }
            , fuzz (list int) "one argument fat arrow function syntax" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "js"
                        , input = "const name = (arg1) => "
                        , output = "const name = () => "
                        , randomNumbers = randomNumbers
                        }
            , fuzz (list int) "two arguments fat arrow function syntax" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "js"
                        , input = "const name = (arg1, arg2) => "
                        , output = "const name = (arg2, arg1) => "
                        , randomNumbers = randomNumbers
                        }
            ]
        , describe "ruby"
            [ fuzz (list int) "one argument" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "rb"
                        , input = "def name(arg1)"
                        , output = "def name()"
                        , randomNumbers = randomNumbers
                        }
            , fuzz (list int) "two arguments" <|
                \randomNumbers ->
                    expectBreakResultWithExt
                        { extension = "rb"
                        , input = "def name(arg1, arg2)"
                        , output = "def name(arg2, arg1)"
                        , randomNumbers = randomNumbers
                        }
            , describe "elm"
                [ fuzz (list int) "one argument" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "elm"
                            , input = "name arg1 ="
                            , output = "name ="
                            , randomNumbers = randomNumbers
                            }
                , fuzz (list int) "two arguments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "elm"
                            , input = "name arg1 arg2 ="
                            , output = "name arg2 arg1 ="
                            , randomNumbers = randomNumbers
                            }
                ]
            , describe "go"
                [ fuzz (list int) "one argument" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "go"
                            , input = "func name(arg)"
                            , output = "func name()"
                            , randomNumbers = randomNumbers
                            }
                , fuzz (list int) "two arguments" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "go"
                            , input = "func name(arg1, arg2)"
                            , output = "func name(arg2, arg1)"
                            , randomNumbers = randomNumbers
                            }
                , fuzz (list int) "two arguments and type specifications" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "go"
                            , input = "func name(arg1 int, arg2 string)"
                            , output = "func name(arg2 string, arg1 int)"
                            , randomNumbers = randomNumbers
                            }
                , fuzz (list int) "weird argument type specifications" <|
                    \randomNumbers ->
                        expectBreakResultWithExt
                            { extension = "go"
                            , input = "func name(arg1 *string, arg2 <-chan int, arg3 []byte, arg4 ...string)"
                            , output = "func name(arg2 <-chan int, arg1 *string, arg3 []byte, arg4 ...string)"
                            , randomNumbers = randomNumbers
                            }

                -- func (m *Mutex)
                -- func (*T2) M2()
                -- func (tv  T)
                -- func (tp *T)
                -- func Split(s string, pos int)
                -- func Greeting(prefix string, who ...string)
                -- func panic(interface{})
                -- func filter(src <-chan int, dst chan<- int, prime int)
                -- func Read(f *File, b []byte)
                ]
            ]
        ]
