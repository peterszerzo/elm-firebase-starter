module Models exposing (..)

import Router
import Models.Auth exposing (Auth)
import Models.MyProfile exposing (MyProfile)


type alias Model =
    { auth : Auth
    , isDevelopment : Bool
    , route : Router.Route
    , myProfile : MyProfile
    }
