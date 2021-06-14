module Stages.Debugging.Model exposing
    ( HelpTab(..)
    , Model
    , Page(..)
    , helpTabToString
    , init
    , showBugLineHint
    , showBugTypeHint
    , updateChange
    )

import List.Extra
import Utils.Types.BrokenFile exposing (BrokenFile, HintVisibility)
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.Encouragements as Encouragements exposing (Encouragements)
import Utils.Types.FilePath exposing (FilePath)


type alias Model =
    { brokenFile : BrokenFile
    , currentHelpTab : HelpTab
    , currentDebuggingTip : Int
    , encouragements : Encouragements
    , currentPage : Page
    }


init : { originalContent : String, updatedContent : String, changes : List ChangeData, path : FilePath } -> Model
init { originalContent, updatedContent, changes, path } =
    { currentPage = StepsPage
    , currentHelpTab = DebuggingTips
    , encouragements = Encouragements.init 0
    , currentDebuggingTip = 0
    , brokenFile =
        { originalContent = originalContent
        , updatedContent = updatedContent
        , changes =
            changes
                |> List.map
                    (\change ->
                        ( change
                        , { showingLineNumber = False
                          , showingBugType = False
                          }
                        )
                    )
        , path = path
        }
    }


type Page
    = StepsPage
    | HelpPage
    | IDontSeeAnyErrorsPage


type HelpTab
    = DebuggingTips
    | BugHints
    | EncourageMe
    | ShowMeTheAnswer


helpTabToString : HelpTab -> String
helpTabToString tab =
    case tab of
        DebuggingTips ->
            "Debugging Tips"

        BugHints ->
            "Bug Hints"

        EncourageMe ->
            "Encouragement"

        ShowMeTheAnswer ->
            "Show Answer"


updateChange : Int -> (( ChangeData, HintVisibility ) -> ( ChangeData, HintVisibility )) -> Model -> Model
updateChange index updateFunc ({ brokenFile } as model) =
    let
        newChanges =
            brokenFile.changes
                |> List.Extra.updateAt index updateFunc

        newBrokenFile =
            { brokenFile | changes = newChanges }
    in
    { model | brokenFile = newBrokenFile }


showBugLineHint : ( ChangeData, HintVisibility ) -> ( ChangeData, HintVisibility )
showBugLineHint ( change, hintVisibility ) =
    ( change, { hintVisibility | showingLineNumber = True } )


showBugTypeHint : ( ChangeData, HintVisibility ) -> ( ChangeData, HintVisibility )
showBugTypeHint ( change, hintVisibility ) =
    ( change, { hintVisibility | showingBugType = True } )
