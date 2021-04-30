module Main exposing (main)

import Browser
import Html exposing (Html)


type alias Model =
    ()


type alias Flags =
    ()


init : Flags -> ( (), Cmd Msg )
init _ =
    ( (), Cmd.none )


view : Model -> { title : String, body : List (Html Msg) }
view _ =
    { title = "Debugging Trainer"
    , body = [ Html.text "Hello there" ]
    }


update : Msg -> Model -> ( (), Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


type Msg
    = NoOp


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
