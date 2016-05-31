module Gif.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Gif.Model exposing (..)
import Gif.Msg exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , img [ imgStyle model.gifUrl ] []
        , br [] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        ]


imgStyle : String -> Attribute msg
imgStyle url =
    style
        [ ( "display", "inline-block" )
        , ( "width", "200px" )
        , ( "height", "200px" )
        , ( "background-position", "center center" )
        , ( "background-size", "cover" )
        , ( "background-image", ("url('" ++ url ++ "')") )
        ]
