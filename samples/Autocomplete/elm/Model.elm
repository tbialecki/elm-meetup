module Model exposing (..)


type alias Model =
    { zipCode : String
    , places : List Place
    , status : SearchStatus
    }


type alias Place =
    { placeName : String
    , state : String
    , latitude : String
    , longitude : String
    }


type SearchStatus
    = Initial
    | Success
    | Error
