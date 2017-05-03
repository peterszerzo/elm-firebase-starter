module Messages.Auth exposing (..)

import Dict


type Msg
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
