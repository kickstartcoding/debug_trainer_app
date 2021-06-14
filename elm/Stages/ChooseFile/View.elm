module Stages.ChooseFile.View exposing (render)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
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
import Utils.Constants as Constants
import Utils.Pluralize as Pluralize
import Utils.SpecialChars exposing (nonbreakingSpaces)
import Utils.Types.FilePath as FilePath
import Utils.UI.Attributes as Attributes
import Utils.UI.Buttons as Buttons
import Utils.UI.Text as Text


render :
    { bugCount : Int
    , startType : StartType
    , status : Status
    }
    -> Element Msg
render { bugCount, startType, status } =
    let
        { fileSelectLabel, startButton } =
            case status of
                JustStarted ->
                    { fileSelectLabel = "choose a file"
                    , startButton = none
                    }

                GotFile file ->
                    { fileSelectLabel = "choose a different file"
                    , startButton =
                        Buttons.button
                            [ Background.color Colors.green
                            , Attributes.title
                                ("click here have "
                                    ++ Constants.appName
                                    ++ " introduce "
                                    ++ Pluralize.aOrSome bugCount "bug"
                                    ++ " into "
                                    ++ FilePath.nameOnly file.path
                                    ++ " so that you can start debugging "
                                    ++ Pluralize.itOrThem bugCount
                                )
                            , centerX
                            ]
                            { msg = BreakFile file
                            , name = startButtonText
                            }
                    }
    in
    el
        [ width fill
        , height fill
        , inFront
            (case status of
                JustStarted ->
                    none

                GotFile file ->
                    FilePath.nameOnly file.path
                        |> howToStartNote bugCount
            )
        ]
    <|
        column
            [ Font.color (rgb 0 0 0)
            , Font.size 25
            , spacing 40
            , centerX
            , centerY
            , Font.center
            ]
            [ column [ spacing 20 ]
                [ paragraph []
                    [ text "How many bugs should I put in your chosen file? "
                    ]
                , Input.text
                    [ htmlAttribute (HtmlAttrs.type_ "number")
                    , htmlAttribute (HtmlAttrs.min "1")
                    , width (maximum 90 fill)
                    , centerX
                    ]
                    { onChange = UpdateBugCount
                    , text = String.fromInt bugCount
                    , placeholder = Nothing
                    , label = Input.labelHidden "the number of bugs you'd like to try debugging"
                    }
                ]
            , column [ spacing 25, centerX ]
                [ paragraph [] [ text "What file should I put the bugs in?" ]
                , paragraph []
                    [ case status of
                        GotFile file ->
                            Text.code (FilePath.nameOnly file.path)

                        JustStarted ->
                            Text.code "[no file selected yet]"
                    ]
                , row [ centerX ]
                    [ Buttons.button [ centerX ]
                        { msg = ChooseFile
                        , name = fileSelectLabel
                        }
                    ]
                ]
            , startButton
            ]


startButtonText : String
startButtonText =
    "let's go!"


howToStartNote : Int-> String ->Element msg
howToStartNote bugCount filename  =
    paragraph
        [ Background.color Colors.darkKickstartCodingBlue
        , Font.color Colors.white
        , Font.center
        , Border.rounded 5
        , paddingXY 20 10
        , alignTop
        , centerX
        ]
        [ text
            ("Click \""
                ++ startButtonText
                ++ "\" to add the "
                ++ Pluralize.singularOrPlural bugCount "bug"
                ++ " and start debugging."
            )
        ]
