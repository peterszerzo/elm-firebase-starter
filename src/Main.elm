module Main exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p)
import Html.Attributes exposing (type_, autocomplete)
import Html.Events exposing (onClick, onInput, onSubmit)
import Commands
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)


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


type alias Model =
    { auth : Auth
    }


init : ( Model, Cmd Msg )
init =
    ( { auth = NotAuthenticated
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


viewLogin : Model -> Html Msg
viewLogin model =
    case model.auth of
        NotAuthenticated ->
            div
                []
                [ div [ onClick InitiateLogin ] [ text "Log in" ]
                , div [ onClick InitiateSignup ] [ text "Sign up" ]
                ]

        LoginFillout user pass ->
            div []
                [ h2 [] [ text "Log in" ]
                , form [ autocomplete False, onSubmit SubmitLogin ]
                    [ label []
                        [ text "User name"
                        , input
                            [ autocomplete False
                            , onInput ChangeLoginUserName
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ autocomplete False
                            , onInput ChangeLoginPassword
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

        LoginError err ->
            div []
                [ h2 [] [ text "Login error" ]
                , p [] [ text err ]
                , p [ onClick InitiateLogin ] [ text "Try again" ]
                ]

        SignupFillout user pass ->
            div []
                [ h2 [] [ text "Sign up" ]
                , form [ onSubmit SubmitSignup ]
                    [ label []
                        [ text "User name"
                        , input
                            [ autocomplete False
                            , onInput ChangeSignupUserName
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ autocomplete False
                            , onInput ChangeSignupPassword
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

        SignupError err ->
            div []
                [ h2 [] [ text "Signup error" ]
                , p [] [ text err ]
                , p [ onClick InitiateSignup ] [ text "Try again" ]
                ]

        LoginPending user ->
            div [] [ text ("Hang in there while we log you in..") ]

        SignupPending user ->
            div [] [ text ("Hang in there while we sign you up..") ]

        LogoutPending ->
            div [] [ text ("Hang in there while we log you out..") ]

        Authenticated user ->
            div []
                [ text ("Hello, " ++ user)
                , div [ onClick InitiateLogout ] [ text "Log out" ]
                ]


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "elm-firebase-starter"
            ]
        , viewLogin model
        ]


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
