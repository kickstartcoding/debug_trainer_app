module Parsers.Generic.SegmentList exposing (countForBreakType, makeAChange)

import Breakers.CaseSwap as CaseSwap
import Breakers.ChangeFunctionArgs as ChangeFunctionArgs
import Breakers.RemoveDotAccess as RemoveDotAccess
import Breakers.RemoveParenthesis as RemoveParenthesis
import Breakers.RemoveReturn as RemoveReturn
import Breakers.Utils
import Parsers.Generic.Segment exposing (Segment)
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FileType exposing (FileType(..))


makeAChange :
    Maybe BreakType
    ->
        { randomNumber : Int
        , originalFileContent : String
        , segments : List Segment
        , fileType : FileType
        }
    -> Maybe ( List Segment, ChangeData )
makeAChange maybeBreakType breakRunnerData =
    case maybeBreakType of
        Just CaseSwap ->
            CaseSwap.run breakRunnerData

        Just RemoveReturn ->
            RemoveReturn.run breakRunnerData

        Just RemoveParenthesis ->
            RemoveParenthesis.run breakRunnerData

        Just ChangeFunctionArgs ->
            ChangeFunctionArgs.run breakRunnerData

        Just RemoveDotAccess ->
            RemoveDotAccess.run breakRunnerData

        Nothing ->
            Nothing


countForBreakType : BreakType -> List Segment -> Int
countForBreakType breakType segments =
    segments
        |> Breakers.Utils.candidates
            (case breakType of
                CaseSwap ->
                    CaseSwap.validCandidateData

                RemoveReturn ->
                    RemoveReturn.validCandidateData

                RemoveParenthesis ->
                    RemoveParenthesis.validCandidateData

                ChangeFunctionArgs ->
                    ChangeFunctionArgs.validCandidateData
                        |> mapToMaybeSegment

                RemoveDotAccess ->
                    RemoveDotAccess.validCandidateData
            )
        |> List.length


mapToMaybeSegment : (Segment -> Maybe data) -> (Segment -> Maybe Segment)
mapToMaybeSegment validityCheck =
    \segment ->
        segment
            |> validityCheck
            |> Maybe.map (\_ -> segment)
