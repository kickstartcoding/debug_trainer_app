module Breakers.ChangeFunctionArgs exposing (run, validCandidateData)

import Breakers.Utils exposing (BreakRunnerData)
import List.Extra as ListEx
import Main.Model exposing (ChangeData)
import Parsers.Generic.Segment
    exposing
        ( BreakStatus(..)
        , Segment
        , SegmentType(..)
        )
import String.Extra
import Utils.FileContent as FileContent
import Utils.Types.BreakType exposing (BreakType(..))
import Utils.Types.FileType exposing (FileType(..))
import Utils.Types.NamedFunctionDeclaration as Function exposing (NamedFunctionDeclaration)


run : BreakRunnerData -> Maybe ( List Segment, ChangeData )
run { randomNumber, originalFileContent, segments, fileType } =
    segments
        |> Breakers.Utils.chooseCandidate randomNumber validCandidateData
        |> Maybe.map
            (\( index, { segment, data, newArguments } ) ->
                let
                    newFuncData =
                        { data | arguments = newArguments }

                    newFuncString =
                        case fileType of
                            Elm ->
                                let
                                    { name, arguments } =
                                        newFuncData
                                in
                                (name ++ " " ++ String.join " " arguments ++ " =")
                                    |> String.Extra.clean

                            JavaScript ->
                                let
                                    { declarationWord, name, arguments } =
                                        newFuncData
                                in
                                if declarationWord == "function" then
                                    Function.toString newFuncData

                                else
                                    declarationWord
                                        ++ " "
                                        ++ name
                                        ++ " = ("
                                        ++ String.join ", " arguments
                                        ++ ") => "

                            _ ->
                                Function.toString newFuncData

                    lineNumber =
                        FileContent.rowFromOffset (segment.offset + String.length segment.content) originalFileContent

                    newSegments =
                        ListEx.setAt index
                            (Segment segment.offset newFuncString (FunctionDeclaration newFuncData BreakHasBeenApplied))
                            segments
                in
                ( newSegments
                , { lineNumber = lineNumber
                  , changeDescription =
                        case ( data.arguments, newArguments ) of
                            ( [ oldArg ], [] ) ->
                                "removed the `" ++ oldArg ++ "` argument from `" ++ data.name ++ "`"

                            ( arg1 :: arg2 :: _, _ ) ->
                                "switched the positions of `" ++ arg1 ++ "` and `" ++ arg2 ++ "` in `" ++ data.name ++ "`"

                            _ ->
                                "error writing change description: unexpected number of arguments"
                  , breakType = ChangeFunctionArgs
                  }
                )
            )


type alias FunctionChangeData =
    { segment : Segment
    , data : NamedFunctionDeclaration
    , newArguments : List String
    }


validCandidateData : Segment -> Maybe FunctionChangeData
validCandidateData ({ segmentType } as segment) =
    case segmentType of
        FunctionDeclaration ({ arguments } as data) BreakNotAppliedYet ->
            let
                dataWithNewArgs newArgs =
                    { segment = segment
                    , data = data
                    , newArguments = newArgs
                    }
            in
            case arguments of
                [] ->
                    Nothing

                [ _ ] ->
                    Just (dataWithNewArgs [])

                arg1 :: arg2 :: tail ->
                    Just (dataWithNewArgs (arg2 :: arg1 :: tail))

        _ ->
            Nothing
