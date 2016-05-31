module Msg exposing (..)

import Model exposing (..)


type Msg
    = NoOp
    | SearchZipCode String
    | SearchSucceed (List Place)
    | SearchFail
