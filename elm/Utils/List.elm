module Utils.List exposing (pickRandom, shuffle)

import List.Extra as ListEx


pickRandom : Int -> List a -> Maybe a
pickRandom seed list =
    let
        listSize =
            List.length list
    in
    if listSize > 0 then
        let
            index =
                modBy listSize seed
        in
        ListEx.getAt index list

    else
        Nothing


shuffle : Int -> List a -> List a
shuffle seed list =
    let
        maybePick =
            pickRandom seed list
    in
    case maybePick of
        Just pick ->
            let
                listWithoutPick =
                    list
                        |> List.filter (not << (==) pick)
            in
            pick :: shuffle seed listWithoutPick

        Nothing ->
            list
