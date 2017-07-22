module Update.Auth exposing (..)

import Dict
import Commands
import Json.Encode as JE
import Router
import Messages exposing (Msg(..), AuthMsg(..))
import Data.Auth exposing (Auth(..))


update : Router.Route -> Messages.AuthMsg -> Auth -> ( Auth, Maybe JE.Value )
update route msg auth =
    case ( msg, auth ) of
        ( InitiateLogin, _ ) ->
            ( LoginFillout "" "", Nothing )

        ( CancelLogin, LoginFillout _ _ ) ->
            ( NotAuthenticated, Nothing )

        ( ChangeLoginEmail email, LoginFillout _ pass ) ->
            ( LoginFillout email pass, Nothing )

        ( ChangeLoginPassword pass, LoginFillout email _ ) ->
            ( LoginFillout email pass, Nothing )

        ( SubmitLogin, LoginFillout email pass ) ->
            ( LoginPending email
            , Commands.login email pass |> Just
            )

        ( UnsuccessfulLogin err, _ ) ->
            ( LoginError err
            , Nothing
            )

        ( UnsuccessfulSignup err, _ ) ->
            ( SignupError err
            , Nothing
            )

        ( InitiateSignup, _ ) ->
            ( SignupFillout "" "", Nothing )

        ( CancelSignup, SignupFillout _ _ ) ->
            ( NotAuthenticated, Nothing )

        ( ChangeSignupEmail email, SignupFillout _ pass ) ->
            ( SignupFillout email pass, Nothing )

        ( ChangeSignupPassword pass, SignupFillout email _ ) ->
            ( SignupFillout email pass, Nothing )

        ( SubmitSignup, SignupFillout email pass ) ->
            ( SignupPending email
            , Commands.signup email pass |> Just
            )

        ( AuthStateChange creds, _ ) ->
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

        ( InitiateLogout, Authenticated _ ) ->
            ( LogoutPending
            , Commands.logout |> Just
            )

        ( _, _ ) ->
            ( auth, Nothing )
