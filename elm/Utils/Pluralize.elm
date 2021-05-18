module Utils.Pluralize exposing (aOrSome, itIsOrTheyAre, singularOrPlural, isOrAre)


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


itIsOrTheyAre : Int -> String
itIsOrTheyAre count =
    if count > 1 then
        "they are"

    else
        "it is"

isOrAre : Int -> String
isOrAre count =
    if count > 1 then
        "are"

    else
        "is"
