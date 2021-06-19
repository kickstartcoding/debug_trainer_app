module TestHelp exposing
    ( expectBreakResult
    , expectBreakResultWithExt
    , expectBreakToFail
    , expectBreakToOutputOneOf
    , expectBreakWithExtToOutputOneOf
    , expectMultiBreakResult
    , expectMultiBreakResultWithExt
    , expectMultiBreakToOutputOneOf
    , expectMultiBreakWithExtToOutputOneOf
    , expectResult
    )

import Main.Update.BreakFile as BreakFile
import Expect
import Utils.Types.FilePath as FilePath


expectResult : (String -> Result errorType dataType) -> String -> dataType -> Expect.Expectation
expectResult parseFunc source expected =
    case parseFunc source of
        Err deadEnds ->
            let
                _ =
                    Debug.log "Unexpected result" deadEnds
            in
            Expect.fail "Expecting success but got Err."

        Ok validResult ->
            Expect.equal validResult expected


expectBreakResult : { input : String, output : String, randomNumbers : List Int } -> Expect.Expectation
expectBreakResult { input, output, randomNumbers } =
    expectBreakResultWithExt
        { extension = "example"
        , input = input
        , output = output
        , randomNumbers = randomNumbers
        }


expectMultiBreakResult : { input : String, output : String, breakCount : Int, randomNumbers : List Int } -> Expect.Expectation
expectMultiBreakResult { input, output, breakCount, randomNumbers } =
    expectMultiBreakResultWithExt
        { extension = "example"
        , input = input
        , output = output
        , randomNumbers = randomNumbers
        , breakCount = breakCount
        }


expectBreakResultWithExt : { extension : String, input : String, output : String, randomNumbers : List Int } -> Expect.Expectation
expectBreakResultWithExt { extension, input, output, randomNumbers } =
    expectMultiBreakResultWithExt
        { extension = extension
        , input = input
        , output = output
        , breakCount = 1
        , randomNumbers = randomNumbers
        }


expectMultiBreakResultWithExt : { extension : String, input : String, output : String, breakCount : Int, randomNumbers : List Int } -> Expect.Expectation
expectMultiBreakResultWithExt { extension, input, output, breakCount, randomNumbers } =
    breakContent { filename = "filepath." ++ extension, content = input, breakCount = breakCount, randomNumbers = randomNumbers }
        |> Expect.equal (Just output)


expectBreakToOutputOneOf : { input : String, outputPossibilities : List String, randomNumbers : List Int } -> Expect.Expectation
expectBreakToOutputOneOf { input, outputPossibilities, randomNumbers } =
    expectBreakWithExtToOutputOneOf
        { extension = "example"
        , input = input
        , outputPossibilities = outputPossibilities
        , randomNumbers = randomNumbers
        }


expectMultiBreakToOutputOneOf : { input : String, outputPossibilities : List String, breakCount : Int, randomNumbers : List Int } -> Expect.Expectation
expectMultiBreakToOutputOneOf { input, outputPossibilities, breakCount, randomNumbers } =
    expectMultiBreakWithExtToOutputOneOf
        { extension = "example"
        , input = input
        , outputPossibilities = outputPossibilities
        , breakCount = breakCount
        , randomNumbers = randomNumbers
        }


expectBreakWithExtToOutputOneOf : { extension : String, input : String, outputPossibilities : List String, randomNumbers : List Int } -> Expect.Expectation
expectBreakWithExtToOutputOneOf { extension, input, outputPossibilities, randomNumbers } =
    expectMultiBreakWithExtToOutputOneOf
        { extension = extension
        , input = input
        , outputPossibilities = outputPossibilities
        , breakCount = 1
        , randomNumbers = randomNumbers
        }


expectMultiBreakWithExtToOutputOneOf : { extension : String, input : String, outputPossibilities : List String, breakCount : Int, randomNumbers : List Int } -> Expect.Expectation
expectMultiBreakWithExtToOutputOneOf { extension, input, outputPossibilities, breakCount, randomNumbers } =
    breakContent { filename = "filepath." ++ extension, content = input, breakCount = breakCount, randomNumbers = randomNumbers }
        |> (\maybeContent ->
                case maybeContent of
                    Just content ->
                        if List.member content outputPossibilities then
                            True

                        else
                            let
                                _ =
                                    Debug.log "Bad updated content" content
                            in
                            False

                    Nothing ->
                        let
                            _ =
                                Debug.log "Unable to break file" ""
                        in
                        False
           )
        |> Expect.equal True


expectBreakToFail : { filename : String, content : String, breakCount : Int, randomNumbers : List Int } -> Expect.Expectation
expectBreakToFail { filename, content, breakCount, randomNumbers } =
    BreakFile.run
        { breakCount = breakCount
        , filepath = FilePath.fromString filename
        , fileContent = content
        , randomNumbers = randomNumbers
        }
        |> Expect.equal Nothing


breakContent : { filename : String, content : String, breakCount : Int, randomNumbers : List Int } -> Maybe String
breakContent { filename, content, breakCount, randomNumbers } =
    BreakFile.run
        { breakCount = breakCount
        , filepath = FilePath.fromString filename
        , fileContent = content
        , randomNumbers = randomNumbers
        }
        |> Maybe.map .newFileContent
