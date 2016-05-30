module App.Update exposing (..)

import App.Model exposing (..)
import App.Msg exposing (..)
import Gif.Update as Gif


init : String -> String -> ( Model, Cmd Msg )
init leftTopic rightTopic =
    let
        ( left, leftFx ) =
            Gif.init leftTopic

        ( right, rightFx ) =
            Gif.init rightTopic
    in
        ( Model left right
        , Cmd.batch
            [ Cmd.map Left leftFx
            , Cmd.map Right rightFx
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Left leftMsg ->
            let
                ( left, leftCmds ) =
                    Gif.update leftMsg model.left
            in
                ( Model left model.right
                , Cmd.map Left leftCmds
                )

        Right rightMsg ->
            let
                ( right, rightCmds ) =
                    Gif.update rightMsg model.right
            in
                ( Model model.left right
                , Cmd.map Right rightCmds
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Left (Gif.subscriptions model.left)
        , Sub.map Right (Gif.subscriptions model.right)
        ]
