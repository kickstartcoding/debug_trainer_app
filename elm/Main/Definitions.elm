module Main.Definitions exposing (..)

import Main.Model exposing (File)
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)
import Utils.Types.FilePath as FilePath exposing (FilePath)



-- FLAGS


flags : Decoder (List Int)
flags =
    TsDecode.list TsDecode.int
        |> TsDecode.field "randomNumbers"



-- STUFF THAT GOES OUT


chooseFile : TsEncode.Encoder ()
chooseFile =
    TsEncode.null


writeFile : TsEncode.Encoder File
writeFile =
    TsEncode.object
        [ TsEncode.required "path" (.path >> FilePath.toString) TsEncode.string
        , TsEncode.required "content" .content TsEncode.string
        ]



-- STUFF THAT COMES IN


gotFileChoice : Decoder File
gotFileChoice =
    TsDecode.succeed File
        |> TsDecode.andMap (TsDecode.field "path" (TsDecode.map FilePath.fromString TsDecode.string))
        |> TsDecode.andMap (TsDecode.field "content" TsDecode.string)


fileChangeWasSaved : Decoder ()
fileChangeWasSaved =
    TsDecode.null ()
