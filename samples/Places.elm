module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)
import Geolocation exposing (Location)
import String


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always (Geolocation.changes CurrentPlace)
        }


type alias Model =
    { zipCode : String
    , places : List Place
    , currentLocation : Maybe Location
    }


type alias Place =
    { placeName : String
    , state : String
    , latitude : String
    , longitude : String
    }


type alias Point =
    { lat : Float
    , lon : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [] Nothing
    , Cmd.none
    )


type Msg
    = NoOp
    | ZipCode String
    | Submit
    | PlacesSuccess (List Place)
    | CurrentPlace Location


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model
            , Cmd.none
            )

        ZipCode zip ->
            ( { model | zipCode = zip }
            , Cmd.none
            )

        Submit ->
            ( model
            , getPlaces model.zipCode
                |> Task.perform (always NoOp) PlacesSuccess
            )

        PlacesSuccess places ->
            ( { model | places = places }
            , Cmd.none
            )

        CurrentPlace location ->
            ( { model | currentLocation = Just location }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ input [ type' "text", placeholder "ZIP code", onInput ZipCode ] []
        , button [ onClick Submit ] [ text "Search" ]
        , br [] []
        , model.places
            |> List.map (placeView model.currentLocation)
            |> ul []
        ]


placeView : Maybe Location -> Place -> Html a
placeView maybeLocation place =
    li []
        (List.map text
            [ place.placeName
            , ", "
            , place.state
            , " ("
            , place.latitude ++ ", " ++ place.longitude
            , getDistance maybeLocation place
            , ")"
            ]
        )


getDistance : Maybe Location -> Place -> String
getDistance maybeLocation place =
    let
        getNumberFromPlace field =
            String.toFloat (field place)
                |> Result.toMaybe

        getDistanceString location lat lon =
            getDistanceFromLatLonInKm
                { lat = location.latitude
                , lon = location.longitude
                }
                { lat = lat
                , lon = lon
                }
                |> round
                |> toString
                |> (\s -> ", about " ++ s ++ " km from here")
    in
        Maybe.map3
            getDistanceString
            maybeLocation
            (getNumberFromPlace .latitude)
            (getNumberFromPlace .longitude)
            |> Maybe.withDefault ""


getDistanceFromLatLonInKm : Point -> Point -> Float
getDistanceFromLatLonInKm point1 point2 =
    let
        earthRadius = 6371
        halfDelta field =
            degrees (field point2 - field point1) / 2
        dLat = halfDelta .lat
        dLon = halfDelta .lon
        a =
            sin dLat ^ 2 + cos (degrees point1.lat) * cos (degrees point2.lat) * sin dLon ^ 2
    in
        earthRadius * 2 * atan2 (sqrt a) (sqrt (1 - a))


getPlaces : String -> Task Http.Error (List Place)
getPlaces zip =
    Http.get decodePlaces ("http://api.zippopotam.us/pl/" ++ zip)


decodePlaces : Json.Decoder (List Place)
decodePlaces =
    Json.at [ "places" ]
        (Json.list
            (Json.object4 Place
                ("place name" := Json.string)
                ("state" := Json.string)
                ("latitude" := Json.string)
                ("longitude" := Json.string)
            )
        )
