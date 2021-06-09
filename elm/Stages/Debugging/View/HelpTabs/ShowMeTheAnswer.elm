module Stages.Debugging.View.HelpTabs.ShowMeTheAnswer exposing (..)

import Array
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (monospace)
import Element.Input as Input
import Stages.Debugging.Msg exposing (Msg(..))
import Utils.Colors as Colors
import Utils.Constants as Constants
import Utils.Types.BrokenFile as BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements exposing (Encouragements)
import Utils.Types.FilePath as FilePath
import Utils.Types.FileType as FileType exposing (FileType)
import Utils.UI.Buttons as Buttons
import Utils.UI.Css as Css
import Utils.UI.Text as Text


render : BrokenFile -> Element Msg
render ({ originalContent, updatedContent, path } as brokenFile) =
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
