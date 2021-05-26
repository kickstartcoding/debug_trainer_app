module Utils.List exposing
    ( nextValidIndex
    , pickRandom
    , previousValidIndex
    , shuffle
    , getByWrappedIndex
    )

import Array
import List.Extra as ListEx


getByWrappedIndex : Int -> List a -> Maybe a
getByWrappedIndex index list =
    let
        wrappedIndex =
            modBy (List.length list) index
    in
    list
        |> Array.fromList
        |> Array.get wrappedIndex


nextValidIndex : Int -> List a -> Int
nextValidIndex currentIndex list =
    modBy (List.length list) (currentIndex + 1)


previousValidIndex : Int -> List a -> Int
previousValidIndex currentIndex list =
    modBy (List.length list) (currentIndex + 1)


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
