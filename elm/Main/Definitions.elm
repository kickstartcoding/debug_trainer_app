module Main.Definitions exposing (..)

import Main.Model exposing (File)
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)



-- STUFF THAT GOES OUT


chooseFile : TsEncode.Encoder ()
chooseFile =
    TsEncode.null


writeFile : TsEncode.Encoder File
writeFile =
    TsEncode.object
        [ TsEncode.required "path" .path TsEncode.string
        , TsEncode.required "content" .content TsEncode.string
        ]



-- STUFF THAT COMES IN


gotFileChoice : Decoder File
gotFileChoice =
    TsDecode.succeed File
        |> TsDecode.andMap (TsDecode.field "path" TsDecode.string)
        |> TsDecode.andMap (TsDecode.field "content" TsDecode.string)
