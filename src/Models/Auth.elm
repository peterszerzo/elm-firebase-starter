module Models.Auth exposing (..)


type Auth
    = NotAuthenticated
    | LoginFillout String String
    | LoginPending String
    | LoginError String
    | SignupFillout String String
    | SignupPending String
    | SignupError String
    | LogoutPending
    | Authenticated String
