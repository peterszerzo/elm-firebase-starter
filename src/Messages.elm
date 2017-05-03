module Messages exposing (..)

import Router
import Messages.Auth
import Messages.MyProfile


type Msg
    = NoOp
    | Navigate String
    | RouteChange Router.Route
    | AuthMsg Messages.Auth.Msg
    | MyProfileMsg Messages.MyProfile.Msg
