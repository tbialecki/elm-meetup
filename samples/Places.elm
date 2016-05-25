module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    { zipCode : String
    , places : List Place
    }


type alias Place =
    { placeName : String
    , state : String
    , latitude : String
    , longitude : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" []
    , Cmd.none
    )


type Msg
    = NoOp
    | ZipCode String
    | Submit
    | PlacesSuccess (List Place)


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


view : Model -> Html Msg
view model =
    div []
        [ input [ type' "text", placeholder "ZIP code", onInput ZipCode ] []
        , button [ onClick Submit ] [ text "Search" ]
        , br [] []
        , model.places
            |> List.map placeView
            |> ul []
        ]


placeView : Place -> Html a
placeView place =
    li []
        (List.map text
            [ place.placeName
            , ", "
            , place.state
            , " ("
            , place.latitude ++ ", " ++ place.longitude
            , ")"
            ]
        )


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
