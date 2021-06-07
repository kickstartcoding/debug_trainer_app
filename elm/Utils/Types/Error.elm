module Utils.Types.Error exposing
    ( Error
    , Report
    , decoding
    , misc
    , reportToString
    )

import Json.Decode


type alias Report =
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : Error
    }


type Error
    = Decoding Json.Decode.Error
    | Misc String


decoding :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : Json.Decode.Error
    }
    -> Report
decoding { error, inModule, action, descriptionForUsers } =
    { descriptionForUsers = descriptionForUsers
    , inModule = inModule
    , action = action
    , error = Decoding error
    }


misc :
    { descriptionForUsers : String
    , inModule : String
    , action : String
    , error : String
    }
    -> Report
misc { error, inModule, action, descriptionForUsers } =
    { descriptionForUsers = descriptionForUsers
    , inModule = inModule
    , action = action
    , error = Misc error
    }


reportToString : Report -> String
reportToString { descriptionForUsers, inModule, action, error } =
    "[ERROR REPORT]\n\nModule: "
        ++ inModule
        ++ "\nAction: "
        ++ action
        ++ "\nContext for users: \""
        ++ descriptionForUsers
        ++ "\"\n\n\nDetails:\n\n"
        ++ (case error of
                Decoding jsonError ->
                    Json.Decode.errorToString jsonError

                Misc errorDescription ->
                    errorDescription
           )
