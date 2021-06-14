module Utils.FileContent exposing (rowFromOffset)


rowFromOffset : Int -> String -> Int
rowFromOffset offset source =
    let
        newlinesCount =
            String.left offset source
                |> String.indexes "\n"
                |> List.length
    in
    newlinesCount + 1
