module Utils.BubbleUp exposing
    ( BubbleUp
    , BubbleUpWithInstruction
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
    { newModel : model
    , cmd : Cmd action
    , bubble : BubbleUpData ()
    }


type alias BubbleUpWithInstruction model action instruction =
    { newModel : model
    , cmd : Cmd action
    , bubble : BubbleUpData instruction
    }


type alias BubbleUpData instruction =
    { error : Maybe Report
    , instruction : Maybe instruction
    }


fromTuple : ( model, Cmd action ) -> BubbleUpWithInstruction model action instruction
fromTuple ( model, cmd ) =
    { newModel = model
    , cmd = cmd
    , bubble = nothing
    }


justModel : model -> BubbleUpWithInstruction model action instruction
justModel model =
    { newModel = model
    , cmd = Cmd.none
    , bubble = nothing
    }


mapModel : (model -> model) -> BubbleUpWithInstruction model action instruction -> BubbleUpWithInstruction model action instruction
mapModel function ({ newModel } as bubbleUp) =
    { bubbleUp | newModel = function newModel }


withDecodingError :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : Json.Decode.Error
    }
    -> BubbleUpWithInstruction model action instruction
    -> BubbleUpWithInstruction model action instruction
withDecodingError errorInfo bubbleUp =
    withError (Error.decoding errorInfo) bubbleUp


withMiscError :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : String
    }
    -> BubbleUpWithInstruction model action instruction
    -> BubbleUpWithInstruction model action instruction
withMiscError errorInfo bubbleUp =
    withError (Error.misc errorInfo) bubbleUp


withError : Report -> BubbleUpWithInstruction model action instruction -> BubbleUpWithInstruction model action instruction
withError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = Just errorReport } }


withMaybeError : Maybe Report -> BubbleUpWithInstruction model action instruction -> BubbleUpWithInstruction model action instruction
withMaybeError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = errorReport } }


withCmd : Cmd action -> BubbleUpWithInstruction model action instruction -> BubbleUpWithInstruction model action instruction
withCmd cmd bubbleUp =
    { bubbleUp | cmd = cmd }


withInstruction : instruction -> BubbleUpWithInstruction model action instruction -> BubbleUpWithInstruction model action instruction
withInstruction instruction ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | instruction = Just instruction } }


nothing : BubbleUpData instruction
nothing =
    { error = Nothing
    , instruction = Nothing
    }
