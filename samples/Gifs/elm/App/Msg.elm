module App.Msg exposing (..)

import Gif.Msg as Gif


type Msg
    = Left Gif.Msg
    | Right Gif.Msg
