module Messages exposing (..)

import Router


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
    | AuthStateChange (Maybe String)


type Msg
    = NoOp
    | Navigate String
    | RouteChange Router.Route
    | AuthMsg AuthMsg
