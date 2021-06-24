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


type alias BubbleUp model msg =
    { newModel : model
    , cmd : Cmd msg
    , bubble : BubbleUpData ()
    }


type alias BubbleUpWithInstruction model msg instruction =
    { newModel : model
    , cmd : Cmd msg
    , bubble : BubbleUpData instruction
    }


type alias BubbleUpData instruction =
    { error : Maybe Report
    , instruction : Maybe instruction
    }


fromTuple : ( model, Cmd msg ) -> BubbleUpWithInstruction model msg instruction
fromTuple ( model, cmd ) =
    { newModel = model
    , cmd = cmd
    , bubble = nothing
    }


justModel : model -> BubbleUpWithInstruction model msg instruction
justModel model =
    { newModel = model
    , cmd = Cmd.none
    , bubble = nothing
    }


mapModel : (model -> model) -> BubbleUpWithInstruction model msg instruction -> BubbleUpWithInstruction model msg instruction
mapModel function ({ newModel } as bubbleUp) =
    { bubbleUp | newModel = function newModel }


withDecodingError :
    { descriptionForUsers : String
    , inModule : String
    , msg : String
    , error : Json.Decode.Error
    }
    -> BubbleUpWithInstruction model msg instruction
    -> BubbleUpWithInstruction model msg instruction
withDecodingError errorInfo bubbleUp =
    withError (Error.decoding errorInfo) bubbleUp


withMiscError :
    { descriptionForUsers : String
    , inModule : String
    , msg : String
    , error : String
    }
    -> BubbleUpWithInstruction model msg instruction
    -> BubbleUpWithInstruction model msg instruction
withMiscError errorInfo bubbleUp =
    withError (Error.misc errorInfo) bubbleUp


withError : Report -> BubbleUpWithInstruction model msg instruction -> BubbleUpWithInstruction model msg instruction
withError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = Just errorReport } }


withMaybeError : Maybe Report -> BubbleUpWithInstruction model msg instruction -> BubbleUpWithInstruction model msg instruction
withMaybeError errorReport ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | error = errorReport } }


withCmd : Cmd msg -> BubbleUpWithInstruction model msg instruction -> BubbleUpWithInstruction model msg instruction
withCmd cmd bubbleUp =
    { bubbleUp | cmd = cmd }


withInstruction : instruction -> BubbleUpWithInstruction model msg instruction -> BubbleUpWithInstruction model msg instruction
withInstruction instruction ({ bubble } as bubbleUp) =
    { bubbleUp | bubble = { bubble | instruction = Just instruction } }


nothing : BubbleUpData instruction
nothing =
    { error = Nothing
    , instruction = Nothing
    }
