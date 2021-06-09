module Stages.Debugging.View.HelpTabs.Encouragement exposing (..)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FileType as FileType exposing (FileType)
import Utils.UI.Buttons as Buttons


render : { bugCount : Int, encouragements : Encouragements, brokenFile : BrokenFile } -> Element Msg
render { bugCount, encouragements, brokenFile } =
    column [ Font.center, spacing 20, height fill, width fill ] <|
        [ el [ centerY, centerX, paddingXY 40 40 ] <|
            paragraph [ Font.size 30 ]
                [ text
                    (encouragements.list
                        |> Array.fromList
                        |> Array.get encouragements.current
                        |> Maybe.withDefault "You're doing great!"
                    )
                ]
        , Buttons.button [ centerX ]
            { msg = SwitchToNextEncouragement
            , name = "say something else encouraging"
            }
        ]
