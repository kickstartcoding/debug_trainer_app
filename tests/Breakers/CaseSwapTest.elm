module Breakers.CaseSwapTest exposing (..)

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
    describe "CaseSwap"
        [ fuzz (list int) "capitalizes" <|
            \randomNumbers ->
                expectBreakResult
                    { input = "word"
                    , output = "Word"
                    , randomNumbers = randomNumbers
                    }
        , fuzz (list int) "lowercases" <|
            \randomNumbers ->
                expectBreakResult
                    { input = "Word"
                    , output = "word"
                    , randomNumbers = randomNumbers
                    }
        ]
