module Parsers.Utils exposing (contentAndResult)

import Parser exposing (..)


contentAndResult : Parser data -> Parser ( String, data )
contentAndResult parser =
    getChompedString parser
        |> andThen
            (\string ->
                case Parser.run parser string of
                    Ok validData ->
                        succeed ( string, validData )

                    Err _ ->
                        Parser.problem
                            ("In contentAndResult function: parsed same content successfully once "
                                ++ "and then failed just after with the same content??? "
                                ++ "This is a bug. Please report it here:\n\n"
                                ++ "https://github.com/kickstartcoding/debug_trainer/issues"
                            )
            )
