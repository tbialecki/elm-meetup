module Gif.Update exposing (..)

import Http
import Json.Decode as Json
import Task
import Gif.Model exposing (..)
import Gif.Msg exposing (..)


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif"
    , getRandomGif topic
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        FetchSucceed newUrl ->
            ( Model model.topic newUrl, Cmd.none )

        FetchFail _ ->
            ( model, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
