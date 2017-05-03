module Update.Auth exposing (..)

import Dict
import Commands
import Router
import Messages exposing (Msg(..))
import Messages.Auth exposing (Msg(..))
import Models exposing (Model)
import Models.Auth exposing (Auth(..))
import Models.MyProfile as MyProfile


update : Messages.Auth.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case ( msg, model.auth ) of
        ( InitiateLogin, _ ) ->
            ( { model | auth = LoginFillout "" "" }, Cmd.none )

        ( CancelLogin, LoginFillout _ _ ) ->
            ( { model | auth = NotAuthenticated }, Cmd.none )

        ( ChangeLoginEmail email, LoginFillout _ pass ) ->
            ( { model | auth = LoginFillout email pass }, Cmd.none )

        ( ChangeLoginPassword pass, LoginFillout email _ ) ->
            ( { model | auth = LoginFillout email pass }, Cmd.none )

        ( SubmitLogin, LoginFillout email pass ) ->
            ( { model | auth = LoginPending email }
            , Commands.login email pass
            )

        ( UnsuccessfulLogin err, _ ) ->
            ( { model | auth = LoginError err }
            , Cmd.none
            )

        ( UnsuccessfulSignup err, _ ) ->
            ( { model | auth = SignupError err }
            , Cmd.none
            )

        ( InitiateSignup, _ ) ->
            ( { model | auth = SignupFillout "" "" }, Cmd.none )

        ( CancelSignup, SignupFillout _ _ ) ->
            ( { model | auth = NotAuthenticated }, Cmd.none )

        ( ChangeSignupEmail email, SignupFillout _ pass ) ->
            ( { model | auth = SignupFillout email pass }, Cmd.none )

        ( ChangeSignupPassword pass, SignupFillout email _ ) ->
            ( { model | auth = SignupFillout email pass }, Cmd.none )

        ( SubmitSignup, SignupFillout email pass ) ->
            ( { model | auth = SignupPending email }
            , Commands.signup email pass
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
                ( { model
                    | auth = auth
                    , myProfile = MyProfile.NotAvailable
                  }
                , case ( auth, model.route ) of
                    ( Authenticated auth, Router.MyProfile ) ->
                        Commands.fetchProfile auth.uid

                    ( _, _ ) ->
                        Cmd.none
                )

        ( InitiateLogout, Authenticated _ ) ->
            ( { model
                | auth = LogoutPending
              }
            , Commands.logout
            )

        ( _, _ ) ->
            ( model, Cmd.none )
