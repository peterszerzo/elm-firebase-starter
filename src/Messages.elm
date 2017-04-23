module Messages exposing (..)


type Msg
    = NoOp
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
