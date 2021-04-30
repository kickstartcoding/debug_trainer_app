module Main.View exposing (render)

import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
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
                [ text "I would like to try debugging fdsf"
                , Input.text [ htmlAttribute (HtmlAttrs.type_ "number") ]
                    { onChange = UpdateFileCount
                    , text = String.fromInt model.fileCount
                    , placeholder = Nothing
                    , label = Input.labelHidden "the number of bugs you'd like to try debugging"
                    }
                , text " bugs "
                ]
            )
        ]
    }
