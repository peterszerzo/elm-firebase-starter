module Main exposing (..)

import Html exposing (programWithFlags)
import Commands
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Models.Auth exposing (Auth(..))
import Models.Main exposing (Model)
import Views.Main exposing (view)


type alias Flags =
    Bool


init : Flags -> ( Model, Cmd Msg )
init isDevelopment =
    ( { auth = NotAuthenticated
      , isDevelopment = isDevelopment
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.auth ) of
        ( InitiateLogin, _ ) ->
            ( { model | auth = LoginFillout "" "" }, Cmd.none )

        ( CancelLogin, LoginFillout _ _ ) ->
            ( { model | auth = NotAuthenticated }, Cmd.none )

        ( ChangeLoginUserName newUser, LoginFillout user pass ) ->
            ( { model | auth = LoginFillout newUser pass }, Cmd.none )

        ( ChangeLoginPassword newPass, LoginFillout user pass ) ->
            ( { model | auth = LoginFillout user newPass }, Cmd.none )

        ( SubmitLogin, LoginFillout user pass ) ->
            ( { model | auth = LoginPending user }
            , Commands.login user pass
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

        ( ChangeSignupUserName newUser, SignupFillout user pass ) ->
            ( { model | auth = SignupFillout newUser pass }, Cmd.none )

        ( ChangeSignupPassword newPass, SignupFillout user pass ) ->
            ( { model | auth = SignupFillout user newPass }, Cmd.none )

        ( SubmitSignup, SignupFillout user pass ) ->
            ( { model | auth = SignupPending user }
            , Commands.signup user pass
            )

        ( AuthStateChange user, _ ) ->
            ( { model
                | auth =
                    case user of
                        Just u ->
                            Authenticated u

                        Nothing ->
                            NotAuthenticated
              }
            , Cmd.none
            )

        ( InitiateLogout, Authenticated user ) ->
            ( { model
                | auth = LogoutPending
              }
            , Commands.logout
            )

        ( _, _ ) ->
            ( model, Cmd.none )


main : Program Flags Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
