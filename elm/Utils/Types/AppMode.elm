module Utils.Types.AppMode exposing (AppMode(..), decoder)

import Json.Encode as JE
import TsJson.Decode as TsDecode exposing (Decoder)


type AppMode
    = Development
    | Production


decoder : Decoder AppMode
decoder =
    TsDecode.oneOf
        [ TsDecode.literal Development (JE.string "development")
        , TsDecode.succeed Production
        ]
