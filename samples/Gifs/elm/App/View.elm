module App.View exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import App.Model exposing (..)
import App.Msg exposing (..)
import Gif.View as Gif


view : Model -> Html Msg
view model =
    div
        [ style [ ( "display", "flex" ) ]
        ]
        [ App.map Left (Gif.view model.left)
        , App.map Right (Gif.view model.right)
        ]
