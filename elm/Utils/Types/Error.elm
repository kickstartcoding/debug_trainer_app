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
    , msg : String
    , error : Error
    }


type Error
    = Decoding Json.Decode.Error
    | Misc String


decoding :
    { descriptionForUsers : String
    , inModule : String
    , msg : String
    , error : Json.Decode.Error
    }
    -> Report
decoding { error, inModule, msg, descriptionForUsers } =
    { descriptionForUsers = descriptionForUsers
    , inModule = inModule
    , msg = msg
    , error = Decoding error
    }


misc :
    { descriptionForUsers : String
    , inModule : String
    , msg : String
    , error : String
    }
    -> Report
misc { error, inModule, msg, descriptionForUsers } =
    { descriptionForUsers = descriptionForUsers
    , inModule = inModule
    , msg = msg
    , error = Misc error
    }


reportToString : Report -> String
reportToString { descriptionForUsers, inModule, msg, error } =
    "[ERROR REPORT]\n\nModule: "
        ++ inModule
        ++ "\nAction: "
        ++ msg
        ++ "\nContext for users: \""
        ++ descriptionForUsers
        ++ "\"\n\n\nDetails:\n\n"
        ++ (case error of
                Decoding jsonError ->
                    Json.Decode.errorToString jsonError

                Misc errorDescription ->
                    errorDescription
           )
