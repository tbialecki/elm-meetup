module Gif.Msg exposing (..)

import Http


type Msg
    = MorePlease
    | FetchSucceed String
    | FetchFail Http.Error
