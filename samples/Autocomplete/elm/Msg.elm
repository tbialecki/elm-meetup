module Msg exposing (..)

import Model exposing (..)


type Msg
    = NoOp
    | SearchZipCode String
    | SearchSucceeded (List Place)
    | SearchFailed
