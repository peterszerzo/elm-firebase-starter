module Update.Auth exposing (..)

import Commands
import Messages exposing (Msg, AuthMsg(..))
import Models.Main exposing (Model)
import Models.Auth exposing (Auth(..))


update : AuthMsg -> Model -> ( Model, Cmd Msg )
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

        ( AuthStateChange maybeEmail, _ ) ->
            ( { model
                | auth =
                    case maybeEmail of
                        Just email ->
                            Authenticated email

                        Nothing ->
                            NotAuthenticated
              }
            , Cmd.none
            )

        ( InitiateLogout, Authenticated _ ) ->
            ( { model
                | auth = LogoutPending
              }
            , Commands.logout
            )

        ( _, _ ) ->
            ( model, Cmd.none )
