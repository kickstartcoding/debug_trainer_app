module Utils.DevModeStartState exposing (get)

import Main.Model exposing (Stage(..))
import Utils.DummyData as DummyData


get : List Int -> Stage
get numbers =
    -- Intro
    -- DummyData.chooseFileStage
    -- DummyData.gotFileStage
    DummyData.debuggingStageStepsPage numbers



-- DummyData.debuggingStageIDontSeeAnyErrorsPage numbers
-- DummyData.debuggingStageBugHintsTab numbers
-- DummyData.debuggingStageTipsTab numbers
-- DummyData.debuggingStageEncouragementTab numbers
-- DummyData.debuggingStageShowAnswerTab numbers
-- DummyData.successfulFinishStage numbers
-- DummyData.shownAnswerFinishedStage numbers
