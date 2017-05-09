module Main exposing (..)

import Navigation exposing (programWithFlags)
import Router
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Models.Auth exposing (Auth(..))
import Models.MyProfile as MyProfile
import Models exposing (Model)
import Update exposing (update, cmdOnRouteChange)
import Views exposing (view)


type alias Flags =
    Bool


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init isDevelopment location =
    let
        route =
            Router.parse location

        model =
            { auth = NotAuthenticated
            , isDevelopment = isDevelopment
            , route = route
            }
    in
        ( model
        , cmdOnRouteChange model route
        )


main : Program Flags Model Msg
main =
    programWithFlags (RouteChange << Router.parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
