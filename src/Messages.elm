module Messages exposing (..)

import Router


type Msg
    = NoOp
    | Navigate String
    | RouteChange Router.Route
    | InitiateLogin
    | ChangeLoginUserName String
    | ChangeLoginPassword String
    | CancelLogin
    | SubmitLogin
    | UnsuccessfulLogin String
    | InitiateSignup
    | ChangeSignupUserName String
    | ChangeSignupPassword String
    | CancelSignup
    | UnsuccessfulSignup String
    | SubmitSignup
    | InitiateLogout
    | AuthStateChange (Maybe String)
