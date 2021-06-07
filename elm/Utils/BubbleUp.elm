module Utils.BubbleUp exposing
    ( BubbleUp
    , BubbleUpWithInstructions
    , fromTuple
    , justModel
    , mapModel
    , withCmd
    , withDecodingError
    , withInstruction
    , withMaybeError
    , withMiscError
    )

import Json.Decode
import Utils.Types.Error as Error exposing (Report)


type alias BubbleUp model action =
    { model : model
    , cmd : Cmd action
    , bubble : BubbleUpData ()
    }


type alias BubbleUpWithInstructions model action instructions =
    { model : model
    , cmd : Cmd action
    , bubble : BubbleUpData instructions
    }


type alias BubbleUpData instructions =
    { error : Maybe Report
    , instructions : Maybe instructions
    }


fromTuple : ( model, Cmd action ) -> BubbleUpWithInstructions model action instructions
fromTuple ( model, cmd ) =
    { model = model
    , cmd = cmd
    , bubble = nothing
    }


justModel : model -> BubbleUpWithInstructions model action instructions
justModel model =
    { model = model
    , cmd = Cmd.none
    , bubble = nothing
    }


mapModel : (model -> model) -> BubbleUpWithInstructions model action instructions -> BubbleUpWithInstructions model action instructions
mapModel function ({ model } as bubbleUp) =
    { bubbleUp | model = function model }


withDecodingError :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : Json.Decode.Error
    }
    -> BubbleUpWithInstructions model action instructions
    -> BubbleUpWithInstructions model action instructions
withDecodingError errorInfo bubbleUp =
    withError (Error.decoding errorInfo) bubbleUp


withMiscError :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : String
    }
    -> BubbleUpWithInstructions model action instructions
    -> BubbleUpWithInstructions model action instructions
withMiscError errorInfo bubbleUp =
    withError (Error.misc errorInfo) bubbleUp


withError : Report -> BubbleUpWithInstructions model action instructions -> BubbleUpWithInstructions model action instructions
withError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = Just errorReport } }


withMaybeError : Maybe Report -> BubbleUpWithInstructions model action instructions -> BubbleUpWithInstructions model action instructions
withMaybeError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = errorReport } }


withCmd : Cmd action -> BubbleUpWithInstructions model action instructions -> BubbleUpWithInstructions model action instructions
withCmd cmd bubbleUp =
    { bubbleUp | cmd = cmd }


withInstruction : instructions -> BubbleUpWithInstructions model action instructions -> BubbleUpWithInstructions model action instructions
withInstruction instructions ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | instructions = Just instructions } }


nothing : BubbleUpData instructions
nothing =
    { error = Nothing
    , instructions = Nothing
    }
