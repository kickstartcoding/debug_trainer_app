module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import Review.Rule exposing (Rule)
import NoDebug.Log
import NoDebug.TodoOrToString
import NoExposingEverything
import NoImportingEverything
import NoMissingTypeAnnotation
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Variables

config : List Rule
config =
    [ 
    NoImportingEverything.rule 
        [ "Element"
        , "Json.Decode"
        , "TsJson.Decode"
        , "Parser"
        ]
    , NoExposingEverything.rule
        |> Review.Rule.ignoreErrorsForFiles 
            [ "elm/Utils/DummyData.elm"
            , "elm/Main/Definitions.elm" 
            ]
    , NoMissingTypeAnnotation.rule
        |> Review.Rule.ignoreErrorsForFiles 
            [ "elm/Main/Interop.elm"
            ]
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Dependencies.rule
    , NoUnused.Exports.rule
        |> Review.Rule.ignoreErrorsForFiles 
            [ "elm/Utils/Types/Error.elm"
            , "elm/Utils/BubbleUp.elm"
            , "elm/Parsers/Utils/Whitespace.elm"
            , "elm/Parsers/Utils/Repeat.elm"
            , "elm/Parsers/Utils/Code.elm"
            ]
    , NoUnused.Modules.rule
        |> Review.Rule.ignoreErrorsForFiles 
            [ "elm/Utils/DummyData.elm"
            ]
    , NoUnused.Variables.rule
        |> Review.Rule.ignoreErrorsForFiles 
            [ "elm/Main/Interop.elm"
            ]
    ]
