module Stages.ChooseFile.Update exposing
    ( Instruction(..)
    , update
    )

import Main.Interop as Interop
import Stages.ChooseFile.Model exposing (File, Model, Status(..))
import Stages.ChooseFile.Msg exposing (Msg(..))
import Utils.BubbleUp as BubbleUp exposing (BubbleUpWithInstruction)


type Instruction
    = UpdateBugCountInstruction Int
    | BreakFileInstruction File


update : { model : Model, msg : Msg } -> BubbleUpWithInstruction Model Msg Instruction
update { model, msg } =
    case msg of
        UpdateBugCount count ->
            case String.toInt count of
                Just bugCount ->
                    model
                        |> BubbleUp.justModel
                        |> BubbleUp.withInstruction (UpdateBugCountInstruction bugCount)

                Nothing ->
                    model
                        |> BubbleUp.justModel
                        |> BubbleUp.withMiscError
                            { action = "UpdateBugCount"
                            , descriptionForUsers = "it looks like you somehow entered a bug count that isn't a valid number"
                            , error = "Couldn't parse the bug count"
                            , inModule = "Stages.ChooseFile.Update"
                            }

        ChooseFile ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withCmd (Interop.chooseFile ())

        FileWasSelected file ->
            { model | status = GotFile file }
                |> BubbleUp.justModel

        PrematureStart ->
            { model | status = TriedToStartWithoutChoosingAFile }
                |> BubbleUp.justModel

        BreakFile file ->
            model
                |> BubbleUp.justModel
                |> BubbleUp.withInstruction (BreakFileInstruction file)
