module Main.Definitions exposing (..)

import Stages.ChooseFile.Model exposing (File)
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode
import Utils.Types.AppMode as AppMode exposing (AppMode)
import Utils.Types.FilePath as FilePath



-- FLAGS


type alias Flags =
    { randomNumbers : List Int
    , logo : String
    , mode : AppMode
    }


flags : Decoder Flags
flags =
    TsDecode.succeed Flags
        |> TsDecode.andMap (TsDecode.field "randomNumbers" (TsDecode.list TsDecode.int))
        |> TsDecode.andMap (TsDecode.field "logo" TsDecode.string)
        |> TsDecode.andMap (TsDecode.field "mode" AppMode.decoder)



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


exit : TsEncode.Encoder ()
exit =
    TsEncode.null


writeFileAndExit : TsEncode.Encoder File
writeFileAndExit =
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


exitShortcutWasPressed : Decoder ()
exitShortcutWasPressed =
    TsDecode.succeed ()
