module Parsers.Utils.Repeat exposing
    ( commaSeparator
    , exactly
    , oneOrMore
    , oneOrMoreWithSeparator
    , oneOrMoreWithWhitespace
    , upTo
    , zeroOrMore
    , zeroOrMoreWithSeparator
    , zeroOrMoreWithWhitespace
    )

import Parser exposing (..)
import Parsers.Utils.Whitespace as Whitespace


zeroOrMore : Parser a -> Parser (List a)
zeroOrMore parseOne =
    loop [] (loopHelp parseOne)


upTo : Int -> Parser a -> Parser (List a)
upTo maxLength parseOne =
    loop ( maxLength, [] ) (upToHelp parseOne)
        |> map Tuple.second


upToHelp : Parser a -> ( Int, List a ) -> Parser (Step ( Int, List a ) ( Int, List a ))
upToHelp parseOne ( maxLength, revList ) =
    if maxLength == 0 then
        succeed ()
            |> map (\_ -> Done ( 0, List.reverse revList ))

    else
        oneOf
            [ succeed (\stmt -> Loop ( maxLength - 1, stmt :: revList ))
                |= parseOne
            , succeed ()
                |> map (\_ -> Done ( 0, List.reverse revList ))
            ]


exactly : Int -> Parser a -> Parser (List a)
exactly maxLength parseOne =
    loop ( maxLength, [] ) (exactlyHelp parseOne)
        |> map Tuple.second


exactlyHelp : Parser a -> ( Int, List a ) -> Parser (Step ( Int, List a ) ( Int, List a ))
exactlyHelp parseOne ( maxLength, revList ) =
    if maxLength == 0 then
        succeed ()
            |> map (\_ -> Done ( 0, List.reverse revList ))

    else
        oneOf
            [ succeed (\stmt -> Loop ( maxLength - 1, stmt :: revList ))
                |= parseOne
            , problem "Wrong number of repeats."
            ]


oneOrMore : Parser a -> Parser (List a)
oneOrMore parseOne =
    let
        loopRemaining : a -> Parser (List a)
        loopRemaining firstOne =
            loop [ firstOne ] (loopHelp parseOne)
    in
    parseOne
        |> andThen loopRemaining


zeroOrMoreWithSeparator : Parser () -> Parser a -> Parser (List a)
zeroOrMoreWithSeparator separator parseOne =
    oneOf
        [ oneOrMoreWithSeparator separator parseOne
        , succeed []
        ]


oneOrMoreWithSeparator : Parser () -> Parser a -> Parser (List a)
oneOrMoreWithSeparator separator parseOne =
    parseOne
        |> andThen
            (\firstElement ->
                succeed (\theRest -> firstElement :: theRest)
                    |= zeroOrMore
                        (succeed identity
                            |. backtrackable separator
                            |= parseOne
                        )
            )


loopHelp : Parser a -> List a -> Parser (Step (List a) (List a))
loopHelp parseOne revList =
    oneOf
        [ succeed (\stmt -> Loop (stmt :: revList))
            |= parseOne
        , succeed ()
            |> map (\_ -> Done (List.reverse revList))
        ]


zeroOrMoreWithWhitespace : Parser a -> Parser (List a)
zeroOrMoreWithWhitespace parseOne =
    succeed identity
        |. Whitespace.optional
        |= zeroOrMoreWithSeparator Whitespace.optional parseOne
        |. Whitespace.optional


oneOrMoreWithWhitespace : Parser a -> Parser (List a)
oneOrMoreWithWhitespace parseOne =
    succeed identity
        |. Whitespace.optional
        |= oneOrMoreWithSeparator Whitespace.optional parseOne
        |. Whitespace.optional


commaSeparator : Parser ()
commaSeparator =
    succeed ()
        |. backtrackable
            (Whitespace.optional
                |. symbol ","
            )
        |. Whitespace.optional
