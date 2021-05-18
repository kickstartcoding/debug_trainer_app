module Main.View.Start exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Main.Model exposing (File, Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.FilePath as FilePath
import Utils.UI.Attributes as Attributes


render : Int -> Maybe File -> Element Msg
render bugCount maybeFile =
    let
        { fileSelectLabel, startButtonTitle, startButtonLabel, startButtonColor, startButtonMsg } =
            case maybeFile of
                Nothing ->
                    { fileSelectLabel = "choose a file"
                    , startButtonLabel = "start"
                    , startButtonColor = Colors.gray
                    , startButtonMsg = Nothing
                    , startButtonTitle = "you can't start until you select a file"
                    }

                Just file ->
                    { fileSelectLabel = "choose a different file"
                    , startButtonLabel = "start debugging"
                    , startButtonColor = Colors.green
                    , startButtonMsg = Just (BreakFile file)
                    , startButtonTitle =
                        "click here to introduce "
                            ++ Pluralize.aOrSome bugCount "bug"
                            ++ " and start debugging them"
                    }
    in
    column
        [ Font.color (rgb 0 0 0)
        , Font.size 25
        , spacing 40
        , centerX
        , centerY
        ]
        [ paragraph [ Font.center, spacing 15 ]
            (List.intersperse (text (nonbreakingSpaces 1)) <|
                [ text "I would like to try debugging "
                , Input.text
                    [ htmlAttribute (HtmlAttrs.type_ "number")
                    , htmlAttribute (HtmlAttrs.min "1")
                    , width (fill |> maximum 90)
                    , Font.center
                    ]
                    { onChange = UpdateBugCount
                    , text = String.fromInt bugCount
                    , placeholder = Nothing
                    , label = Input.labelHidden "the number of bugs you'd like to try debugging"
                    }
                , text (" " ++ Pluralize.singularOrPlural bugCount "bug" ++ " in ")
                , case maybeFile of
                    Just file ->
                        paragraph
                            [ Background.color (Colors.darkened 0.5)
                            , Font.color Colors.white
                            , paddingXY 10 5
                            , rounded 5
                            ]
                            [ text (FilePath.toString file.path)
                            ]

                    Nothing ->
                        none
                ]
            )
        , row [ centerX, spacing 30 ]
            [ Input.button
                [ Background.color Colors.purple
                , Font.color Colors.white
                , paddingXY 35 20
                , rounded 5
                , centerX
                ]
                { onPress = Just ChooseFile
                , label = text fileSelectLabel
                }
            ]
        , Input.button
            [ Background.color startButtonColor
            , Font.color Colors.white
            , paddingXY 35 20
            , rounded 5
            , centerX
            , Attributes.title startButtonTitle
            ]
            { onPress = startButtonMsg
            , label = text startButtonLabel
            }
        ]
