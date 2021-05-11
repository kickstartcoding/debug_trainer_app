module Main.Definitions exposing (..)

import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)



-- STUFF THAT GOES OUT


chooseFile : TsEncode.Encoder ()
chooseFile =
    TsEncode.null



-- STUFF THAT COMES IN


gotFileChoice : Decoder String
gotFileChoice =
    TsDecode.string
