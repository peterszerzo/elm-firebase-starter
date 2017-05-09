module Models exposing (..)

import Router
import Models.Auth exposing (Auth)


type alias Model =
    { auth : Auth
    , isDevelopment : Bool
    , route : Router.Route
    }
