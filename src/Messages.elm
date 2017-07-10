module Messages exposing (..)

import Dict
import Router
import Page.MyProfile


type AuthMsg
    = InitiateLogin
    | ChangeLoginEmail String
    | ChangeLoginPassword String
    | CancelLogin
    | SubmitLogin
    | UnsuccessfulLogin String
    | InitiateSignup
    | ChangeSignupEmail String
    | ChangeSignupPassword String
    | CancelSignup
    | UnsuccessfulSignup String
    | SubmitSignup
    | InitiateLogout
    | AuthStateChange (Dict.Dict String String)


type Msg
    = NoOp
    | Navigate String
    | RouteChange Router.Route
    | AuthChange AuthMsg
    | MyProfileChange Page.MyProfile.Msg
