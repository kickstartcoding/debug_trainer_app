module Main.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import File.Select
import Html exposing (Html)
import Html.Attributes as HtmlAttrs
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.SpecialChars exposing (nonbreakingSpaces)


render : Model -> { title : String, body : List (Html Msg) }
render model =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill, paddingXY 20 40 ]
            (column
                [ Font.color (rgb 0 0 0)
                , Font.size 25
                , spacing 30
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
                            , text = String.fromInt model.bugCount
                            , placeholder = Nothing
                            , label = Input.labelHidden "the number of bugs you'd like to try debugging"
                            }
                        , text
                            (" "
                                ++ (if model.bugCount > 1 then
                                        "bugs"

                                    else
                                        "bug"
                                   )
                                ++ " in "
                            )
                        ]
                    )
                , Input.button
                    [ Background.color Colors.purple
                    , Font.color Colors.white
                    , paddingXY 35 20
                    , rounded 5
                    , centerX
                    ]
                    { onPress = Just ChooseFile
                    , label = text "choose a file or folder"
                    }
                ]
            )
        ]
    }
