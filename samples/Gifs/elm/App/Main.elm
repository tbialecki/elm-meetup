module App.Main exposing (..)

import Html.App as App
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)


main =
    App.program
        { init = init "funny cats" "funny dogs"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
