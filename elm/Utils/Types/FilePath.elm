module Utils.Types.FilePath exposing
    ( FilePath
    , fromString
    , toString
    )


type FilePath
    = FilePath String


toString : FilePath -> String
toString (FilePath string) =
    string


fromString : String -> FilePath
fromString string =
    FilePath string
