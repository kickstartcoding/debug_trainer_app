module Main.Model exposing (Model)

import File exposing (File)


type alias Model =
    { bugCount : Int
    , target : Maybe File
    }



-- type Target =
--   File File
--   | Folder
