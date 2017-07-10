module Update.Auth exposing (..)

import Dict
import Commands
import Json.Encode as JE
import Router
import Messages exposing (Msg(..), AuthMsg(..))
import Data.Auth exposing (Auth(..))


update : Router.Route -> Messages.AuthMsg -> Auth -> ( Auth, Maybe JE.Value )
update route msg auth =
    case ( route, msg, auth ) of
        ( _, InitiateLogin, _ ) ->
            ( LoginFillout "" "", Nothing )

        ( _, CancelLogin, LoginFillout _ _ ) ->
            ( NotAuthenticated, Nothing )

        ( _, ChangeLoginEmail email, LoginFillout _ pass ) ->
            ( LoginFillout email pass, Nothing )

        ( _, ChangeLoginPassword pass, LoginFillout email _ ) ->
            ( LoginFillout email pass, Nothing )

        ( _, SubmitLogin, LoginFillout email pass ) ->
            ( LoginPending email
            , Commands.login email pass |> Just
            )

        ( _, UnsuccessfulLogin err, _ ) ->
            ( LoginError err
            , Nothing
            )

        ( _, UnsuccessfulSignup err, _ ) ->
            ( SignupError err
            , Nothing
            )

        ( _, InitiateSignup, _ ) ->
            ( SignupFillout "" "", Nothing )

        ( _, CancelSignup, SignupFillout _ _ ) ->
            ( NotAuthenticated, Nothing )

        ( _, ChangeSignupEmail email, SignupFillout _ pass ) ->
            ( SignupFillout email pass, Nothing )

        ( _, ChangeSignupPassword pass, SignupFillout email _ ) ->
            ( SignupFillout email pass, Nothing )

        ( _, SubmitSignup, SignupFillout email pass ) ->
            ( SignupPending email
            , Commands.signup email pass |> Just
            )

        ( route, AuthStateChange creds, _ ) ->
            let
                auth =
                    case ( Dict.get "uid" creds, Dict.get "email" creds ) of
                        ( Just uid, Just email ) ->
                            Authenticated { uid = uid, email = email }

                        ( _, _ ) ->
                            NotAuthenticated
            in
                ( auth
                , case ( auth, route ) of
                    ( Authenticated auth, Router.MyProfile _ ) ->
                        Commands.fetchProfile auth.uid |> Just

                    ( _, _ ) ->
                        Nothing
                )

        ( _, InitiateLogout, Authenticated _ ) ->
            ( LogoutPending
            , Commands.logout |> Just
            )

        ( _, _, _ ) ->
            ( auth, Nothing )
