module Main.View exposing (render)

import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import File.Select
import Html exposing (Html)
import Html.Attributes as HtmlAttrs
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


render : Model -> { title : String, body : List (Html Msg) }
render model =
    { title = "Debugging Trainer"
    , body =
        [ layout [ width fill, height fill ]
            (row [ Font.color (rgb 0 0 0), width fill, height fill ]
                [ paragraph [ Font.center, spacing 15 ]
                    [ el [] (text "I would like to try debugging ")
                    , Input.text
                        [ htmlAttribute (HtmlAttrs.type_ "number")
                        , htmlAttribute (HtmlAttrs.min "1")
                        , width (fill |> maximum 90)
                        , Font.center
                        ]
                        { onChange = UpdatebugCount
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
                    , Input.button []
                        { onPress = Just ChooseFile
                        , label = text "choose a file or folder"
                        }
                    ]
                ]
            )
        ]
    }
