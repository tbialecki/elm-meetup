module Update exposing (..)

import Task exposing (Task)
import Http
import Json.Decode as Json exposing ((:=))
import Regex
import Model exposing (..)
import Msg exposing (..)


init : ( Model, Cmd Msg )
init =
    ( Model "" [] Initial
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SearchZipCode zipCode ->
            let
                searchPlaces =
                    getPlaces zipCode
                        |> Task.perform (always SearchFail) SearchSucceed

                foundPlaces =
                    if isZipCodeValid zipCode then
                        searchPlaces
                    else
                        Cmd.none
            in
                ( { model | zipCode = zipCode }, foundPlaces )

        SearchSucceed places ->
            ( { model
                | places = places
                , status = Success
              }
            , Cmd.none
            )

        SearchFail ->
            ( { model | status = Error }, Cmd.none )


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


isZipCodeValid : String -> Bool
isZipCodeValid zipCode =
    let
        pattern =
            "[0-9]{2}-[0-9]{3}"

        regex =
            Regex.regex pattern
    in
        Regex.contains regex zipCode
