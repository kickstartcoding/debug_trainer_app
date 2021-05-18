module Utils.FileContent exposing (colFromOffset, getRow, rowFromOffset)

import Array


getRow : Int -> String -> String
getRow row string =
    string
        |> String.lines
        |> Array.fromList
        |> Array.get (row - 1)
        |> Maybe.withDefault
            ("Couldn't find line number "
                ++ String.fromInt row
                ++ " in this string."
            )


rowFromOffset : Int -> String -> Int
rowFromOffset offset source =
    let
        newlinesCount =
            String.left offset source
                |> String.indexes "\n"
                |> List.length
    in
    newlinesCount + 1


colFromOffset : Int -> String -> Int
colFromOffset offset source =
    let
        lastNewlineIndex =
            String.left offset source
                |> String.indexes "\n"
                |> List.reverse
                |> List.head

        lengthOfPreviousLines =
            case lastNewlineIndex of
                Just index ->
                    index + 1

                Nothing ->
                    0
    in
    (offset - lengthOfPreviousLines) + 1
