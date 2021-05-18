module Utils.List exposing (pickRandom)

import List.Extra as ListEx


pickRandom : Int -> List a -> Maybe a
pickRandom seed candidateList =
    let
        listSize =
            List.length candidateList
    in
    if listSize > 0 then
        let
            index =
                modBy listSize seed
        in
        ListEx.getAt index candidateList

    else
        Nothing
