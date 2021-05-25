module Main exposing (main)

import Browser
import Json.Decode exposing (Value)
import Main.Interop
import Main.Model exposing (DebuggingInterfaceTab(..), Error(..), Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Subscriptions
import Main.Update
import Main.View
import Utils.List
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.FilePath as FilePath


init : Value -> ( Model, Cmd Msg )
init flags =
    let
        { randomNumbers, startingError, randomizedEncouragements } =
            case Main.Interop.decodeFlags flags of
                Ok ((firstRandomNumber :: _) as numbers) ->
                    { randomNumbers = numbers
                    , startingError = Nothing
                    , randomizedEncouragements = Utils.List.shuffle firstRandomNumber encouragements
                    }

                Ok [] ->
                    { randomNumbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
                    , startingError = Just (BadFlags "Got an empty list of random numbers")
                    , randomizedEncouragements = encouragements
                    }

                Err error ->
                    { randomNumbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
                    , startingError = Just (BadFlags (Json.Decode.errorToString error))
                    , randomizedEncouragements = encouragements
                    }
    in
    ( { bugCount = 1
      , randomNumbers = randomNumbers
      , lastDisplayedEncouragement = Nothing
      , encouragements =
            { list = randomizedEncouragements
            , current = 0
            }

      -- , stage = Start
      --   , stage =
      --         GotFile
      --             { path = FilePath.fromString "/test/testfile.js"
      --             , content = "function a (a, b, c) { return c }; a()"
      --             }
      , stage =
            BrokeFile
                { originalContent = "function a (a, b, c) { return c }; a()"
                , updatedContent = "function a (b, a, c) { return c }; a()"
                , changes =
                    [ ( { lineNumber = 1
                        , breakType = ChangeFunctionArgs
                        , changeDescription = "swapped some goddamn args"
                        }
                      , { showingLineNumber = False
                        , showingBugType = False
                        }
                      )
                    , ( { lineNumber = 5
                        , breakType = RemoveParenthesis
                        , changeDescription = "removed a paren"
                        }
                      , { showingLineNumber = False
                        , showingBugType = False
                        }
                      )
                    ]
                , path = FilePath.fromString "testfile.js"
                }
                (ImHavingTroublePage False)
      , maybeError = startingError
      }
    , Cmd.none
    )


encouragements : List String
encouragements =
    [ "Debugging is genuinely hard! Don't sweat it if it takes time, and if it's really frustrating, just look at the solution this time — you can learn just as much from that as from struggling to solve it."
    , "I would make you an adorable yet encouraging cross-stitch, but I'm a computer and I don't have any arms."
    , " 💫 🌟 🎉 I believe in you! 🎉 ✨ ⭐️ "
    , "Good job asking for encouragement! Sometimes that's hard, but you deserve it!"
    , "You're doing a good job! If you've been working at this a while, give yourself the time and space to take a break for a bit."
    ]


main : Program Value Model Msg
main =
    Browser.document
        { init = init
        , view = Main.View.render
        , update = Main.Update.update
        , subscriptions = Main.Subscriptions.subscriptions
        }
