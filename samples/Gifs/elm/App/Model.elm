module App.Model exposing (..)

import Gif.Model as Gif

type alias Model =
  { left : Gif.Model
  , right : Gif.Model
  }