module Stages.Debugging.View.HelpTabs.ShowMeTheAnswer exposing (render)

import Element exposing (..)
import Element.Font as Font
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Constants as Constants
import Utils.Types.BrokenFile as BrokenFile exposing (BrokenFile)
import Utils.UI.Buttons as Buttons


render : BrokenFile -> Element Msg
render brokenFile =
    column
        [ centerX
        , centerY
        , spacing 30
        ]
        [ paragraph
            [ width (px 400)
            , Font.center
            ]
            [ text
                ("Can't figure out the "
                    ++ BrokenFile.bugOrBugsString brokenFile
                    ++ "? No problem, click the button below to show exactly what "
                    ++ Constants.appName
                    ++ " did to the file."
                )
            ]
        , Buttons.button
            [ centerX ]
            { msg = ShowTheAnswer
            , name = "show me the answer"
            }
        ]
