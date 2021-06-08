module Stages.ChooseFile.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (rounded)
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttrs
import Stages.ChooseFile.Model
    exposing
        ( File
        , Model
        , StartType(..)
        , Status(..)
        )
import Stages.ChooseFile.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.FilePath as FilePath
import Utils.UI.Attributes as Attributes
import Utils.UI.Buttons as Buttons


render :
    { bugCount : Int
    , startType : StartType
    , status : Status
    }
    -> Element Msg
render { bugCount, startType, status } =
    let
        { fileSelectLabel, startButtonTitle, startButtonLabel, startButtonColor, startButtonMsg } =
            case status of
                JustStarted ->
                    { fileSelectLabel = "choose a file"
                    , startButtonLabel = "start"
                    , startButtonColor = Colors.gray
                    , startButtonMsg = Nothing
                    , startButtonTitle = "you can't start until you choose a file"
                    }

                GotFile file ->
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
                    , width (maximum 90 fill)
                    , Font.center
                    ]
                    { onChange = UpdateBugCount
                    , text = String.fromInt bugCount
                    , placeholder = Nothing
                    , label = Input.labelHidden "the number of bugs you'd like to try debugging"
                    }
                , text (" " ++ Pluralize.singularOrPlural bugCount "bug" ++ " in ")
                , case status of
                    GotFile file ->
                        paragraph
                            [ Background.color (Colors.darkened 0.5)
                            , Font.color Colors.white
                            , paddingXY 10 5
                            , rounded 5
                            ]
                            [ text (FilePath.toString file.path)
                            ]

                    JustStarted ->
                        none
                ]
            )
        , row [ centerX, spacing 30 ]
            [ Buttons.button [ centerX ]
                { msg = ChooseFile
                , name = fileSelectLabel
                }
            ]
        , Buttons.disableableButton
            [ Background.color startButtonColor
            , Attributes.title startButtonTitle
            , centerX
            ]
            { maybeMsg = startButtonMsg
            , name = startButtonLabel
            }
        ]
