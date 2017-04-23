module Main exposing (..)

import Navigation exposing (programWithFlags)
import Router
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Models.Auth exposing (Auth(..))
import Models.Main exposing (Model)
import Update.Main exposing (update)
import Views.Main exposing (view)


type alias Flags =
    Bool


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init isDevelopment location =
    ( { auth = NotAuthenticated
      , isDevelopment = isDevelopment
      , route = Router.parse location
      }
    , Cmd.none
    )


main : Program Flags Model Msg
main =
    programWithFlags (RouteChange << Router.parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
