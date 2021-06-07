port module Main.Interop exposing
    ( ToElm(..)
    , toElm
    , decodeFlags
    , writeFile
    , writeFileAndExit
    , chooseFile
    )


import Main.Definitions
import Json.Decode
import Json.Encode
import TsJson.Decode as TsDecode
import TsJson.Encode as TsEncode exposing (Encoder)
import TsJson.Type
import Main.Model

decodeFlags flags =
    Json.Decode.decodeValue
        (Main.Definitions.flags |> TsDecode.decoder)
        flags



writeFile argument____ =
    argument____
      |> encodeProVariant "writeFile" Main.Definitions.writeFile
      |> interopFromElm


writeFileAndExit argument____ =
    argument____
      |> encodeProVariant "writeFileAndExit" Main.Definitions.writeFileAndExit
      |> interopFromElm


chooseFile argument____ =
    argument____
      |> encodeProVariant "chooseFile" Main.Definitions.chooseFile
      |> interopFromElm



type ToElm
    = GotFileChoice Main.Model.File
    | FileChangeWasSaved ()


toElm : Sub (Result Json.Decode.Error ToElm)
toElm =
    (toElmDecoder____ |> TsDecode.decoder)
        |> Json.Decode.decodeValue
        |> interopToElm


toElmDecoder____ : TsDecode.Decoder ToElm
toElmDecoder____ =
    TsDecode.oneOf
        [ toElmVariant "gotFileChoice" GotFileChoice Main.Definitions.gotFileChoice
    , toElmVariant "fileChangeWasSaved" FileChangeWasSaved Main.Definitions.fileChangeWasSaved
        ]


toElmVariant : String -> (value -> a) -> TsDecode.Decoder value -> TsDecode.Decoder a
toElmVariant tagName constructor decoder____ =
    TsDecode.field "tag" (TsDecode.literal constructor (Json.Encode.string tagName))
        |> TsDecode.andMap (TsDecode.field "data" decoder____)


proVariantAnnotation :
    String
    -> Encoder arg
    -> String
proVariantAnnotation variantName encoder_ =
    TsEncode.object
        [ TsEncode.required "tag" identity (TsEncode.literal (Json.Encode.string variantName))
        , TsEncode.required "data" identity encoder_
        ]
        |> TsEncode.tsType
        |> TsJson.Type.toTypeScript


encodeProVariant :
    String
    -> Encoder arg1
    -> arg1
    -> Json.Encode.Value
encodeProVariant variantName encoder_ arg1 =
    arg1
        |> (TsEncode.object
                [ TsEncode.required "tag" identity (TsEncode.literal (Json.Encode.string variantName))
                , TsEncode.required "data" identity encoder_
                ]
                |> TsEncode.encoder
           )


port interopFromElm : Json.Encode.Value -> Cmd msg


port interopToElm : (Json.Decode.Value -> msg) -> Sub msg
