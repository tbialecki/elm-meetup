module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Debug


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "span8" ]
            [ div [ class "hero-unit" ]
                [ h2 [] [ text "Zippoptamus" ]
                , br [] []
                , p []
                    [ text "Try entering a zip code like 00-200 Warszawa"
                    ]
                , br [] []
                , resultView model
                ]
            ]
        ]


resultView : Model -> Html Msg
resultView model =
    let
        ( hideResult, statusClass ) =
            case model.status of
                Initial ->
                    ( True, "control-group" )

                Success ->
                    ( False, "control-group success" )

                Error ->
                    ( True, "control-group error" )

        ( city, state ) =
            extractCityAndState model.places
    in
        fieldset []
            [ legend [] [ text "Polish Address Completion" ]
            , br [] []
            , div []
                [ div [ class statusClass ]
                    [ label [ for "zip" ] [ text "Zip" ]
                    , input
                        [ type' "text"
                        , name "zip"
                        , placeholder "Type your ZIP here "
                        , onInput SearchZipCode
                        ]
                        []
                    ]
                ]
            , div [ hidden hideResult ]
                [ div []
                    [ label [ for "city" ] [ text "City" ]
                    , input
                        [ type' "text"
                        , name "city"
                        , value city
                        ]
                        []
                    ]
                , div []
                    [ label [ for "state" ] [ text "State" ]
                    , input
                        [ type' "text"
                        , name "state"
                        , value state
                        ]
                        []
                    ]
                ]
            ]


extractCityAndState : List Place -> ( String, String )
extractCityAndState places =
    case List.head places of
        Just place ->
            ( place.placeName, place.state )

        Nothing ->
            ( "", "" )
