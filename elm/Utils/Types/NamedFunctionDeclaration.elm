module Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration, toString)


type alias NamedFunctionDeclaration =
    { declarationWord : String
    , name : String
    , arguments : List String
    }


toString : NamedFunctionDeclaration -> String
toString { declarationWord, name, arguments } =
    declarationWord ++ " " ++ name ++ "(" ++ String.join ", " arguments ++ ")"
