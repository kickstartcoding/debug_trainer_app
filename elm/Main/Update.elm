module Main.Update exposing (update)

import List.Extra
import Main.Interop as Interop
import Main.Model exposing (DebuggingInterfaceTab(..), Error(..), HintVisibility, Model, Stage(..))
import Main.Msg exposing (Msg(..))
import Main.Update.BreakFile as BreakFile
import Utils.Types.ChangeData exposing (ChangeData)
import Utils.Types.FilePath as FilePath


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateBugCount count ->
            case String.toInt count of
                Just bugCount ->
                    ( { model | bugCount = bugCount }, Cmd.none )

                Nothing ->
                    ( { model | maybeError = Just (CouldntParseBugCount count) }, Cmd.none )

        ChooseFile ->
            ( model, Interop.chooseFile () )

        FileWasSelected file ->
            ( { model | stage = GotFile file }, Cmd.none )

        BreakFile { path, content } ->
            let
                result =
                    BreakFile.run
                        { breakCount = model.bugCount
                        , filepath = path
                        , fileContent = content
                        , randomNumbers = model.randomNumbers
                        }
            in
            case result of
                Just { newFileContent, changes } ->
                    ( { model
                        | stage =
                            BrokeFile
                                { originalContent = content
                                , updatedContent = newFileContent
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
                                StepsPage
                      }
                    , Interop.writeFile
                        { path = path
                        , content = newFileContent
                        }
                    )

                Nothing ->
                    ( { model | maybeError = Just (CouldntBreakSelectedFile (FilePath.toString path)) }, Cmd.none )

        FileWasBroken ->
            ( model, Cmd.none )

        ChangeInterfaceTab newTab brokenFile ->
            ( { model | stage = BrokeFile brokenFile newTab }, Cmd.none )

        ShowBugLineHint ({ changes } as brokenFile) bugIndex ->
            let
                newChanges =
                    changes
                        |> List.Extra.updateAt bugIndex showBugLineHint
            in
            ( { model | stage = BrokeFile { brokenFile | changes = newChanges } ImHavingTroublePage }, Cmd.none )

        ShowBugTypeHint ({ changes } as brokenFile) bugIndex ->
            let
                newChanges =
                    changes
                        |> List.Extra.updateAt bugIndex showBugTypeHint
            in
            ( { model | stage = BrokeFile { brokenFile | changes = newChanges } ImHavingTroublePage }, Cmd.none )

        InteropError error ->
            ( { model | maybeError = Just (BadInterop error) }, Cmd.none )


showBugLineHint : ( ChangeData, HintVisibility ) -> ( ChangeData, HintVisibility )
showBugLineHint ( change, hintVisibility ) =
    ( change, { hintVisibility | showingLineNumber = True } )


showBugTypeHint : ( ChangeData, HintVisibility ) -> ( ChangeData, HintVisibility )
showBugTypeHint ( change, hintVisibility ) =
    ( change, { hintVisibility | showingBugType = True } )
