module Utils.Pluralize exposing
    ( aOrSome
    , isOrAre
    , itIsOrTheyAre
    , itOrThem
    , singularOrPlural
    )


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


itOrThem : Int -> String
itOrThem count =
    if count > 1 then
        "them"

    else
        "it"


isOrAre : Int -> String
isOrAre count =
    if count > 1 then
        "are"

    else
        "is"
