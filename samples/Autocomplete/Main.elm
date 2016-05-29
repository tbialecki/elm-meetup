module Main exposing (..)

import Platform.Sub exposing (Sub)
import Html.App as Html
import Model exposing (..)
import Msg exposing (..)
import View exposing (..)
import Update exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
