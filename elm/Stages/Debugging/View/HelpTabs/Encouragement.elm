module Stages.Debugging.View.HelpTabs.Encouragement exposing (render)

import Array
import Element exposing (..)
import Element.Font as Font
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Types.BrokenFile exposing (BrokenFile)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.UI.Buttons as Buttons


render : { requestedBugCount : Int, encouragements : Encouragements, brokenFile : BrokenFile } -> Element Msg
render { encouragements } =
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
