module Utils.Pluralize exposing (aOrSome, singularOrPlural)


singularOrPlural : Int -> String -> String
singularOrPlural count term =
    if count > 1 then
        term ++ "s"

    else
        term


aOrSome : Int -> String -> String
aOrSome count term =
    if count > 1 then
        "some " ++ term ++ "s"

    else
        "a " ++ term
