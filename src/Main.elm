port module Main exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input)
import Html.Attributes exposing (type_, autocomplete)
import Html.Events exposing (onClick, onInput, onSubmit)


type Auth
    = NotAuthenticated
    | LoginFillout String String
    | LoginPending String
    | LoginError String
    | SignupFillout String String
    | SignupPending String
    | SignupError String
    | LoggingOut
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


type Msg
    = NoOp
    | InitiateLogin
    | ChangeLoginUserName String
    | ChangeLoginPassword String
    | CancelLogin
    | SubmitLogin
    | InitiateSignup
    | ChangeSignupUserName String
    | ChangeSignupPassword String
    | CancelSignup
    | SubmitSignup
    | InitiateLogout
    | AuthStateChange (Maybe String)


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
            , outgoing ("login" ++ "|" ++ user ++ "|" ++ pass)
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
            , outgoing ("signup" ++ "|" ++ user ++ "|" ++ pass)
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
                | auth = LoggingOut
              }
            , outgoing "logout"
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

        LoginPending user ->
            div [] [ text ("Hang in there while we log you in..") ]

        Authenticated user ->
            div []
                [ text ("Hello, " ++ user)
                , div [ onClick InitiateLogout ] [ text "Log out" ]
                ]

        _ ->
            div [] []


port outgoing : String -> Cmd msg


port incoming : (String -> msg) -> Sub msg


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "elm-firebase-starter"
            ]
        , viewLogin model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    incoming
        (\s ->
            if (String.left 5 s == "login") then
                AuthStateChange (Just (String.dropLeft 6 s))
            else if (s == "logout") then
                AuthStateChange (Nothing)
            else
                NoOp
        )


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
