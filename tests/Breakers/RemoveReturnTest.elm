module Breakers.RemoveReturnTest exposing (..)

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
    describe "RemoveReturn"
        [ fuzz (list int) "return removal" <|
            \randomNumbers ->
                expectBreakResult
                    { input = "return "
                    , output = ""
                    , randomNumbers = randomNumbers
                    }
        ]
