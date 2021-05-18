module Parsers.Generic.Segment exposing
    ( BreakStatus(..)
    , Segment
    , SegmentType(..)
    )

import Utils.Types.NamedFunctionDeclaration exposing (NamedFunctionDeclaration)


type SegmentType
    = Word BreakStatus
    | ReturnStatement BreakStatus
    | ParenthesisOrBracket BreakStatus
    | DotAccess BreakStatus
    | FunctionDeclaration NamedFunctionDeclaration BreakStatus
    | Whitespace
    | String
    | Comment
    | Other


type BreakStatus
    = BreakHasBeenApplied
    | BreakNotAppliedYet


type alias Segment =
    { offset : Int
    , content : String
    , segmentType : SegmentType
    }
