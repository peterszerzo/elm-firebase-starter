module Models.Auth exposing (..)

import Models.User exposing (User)


type Auth
    = NotAuthenticated
    | LoginFillout String String
    | LoginPending String
    | LoginError String
    | SignupFillout String String
    | SignupPending String
    | SignupError String
    | LogoutPending
    | Authenticated User
