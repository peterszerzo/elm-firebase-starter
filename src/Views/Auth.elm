module Views.Auth exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick, onInput, onSubmit)
import Models.Auth exposing (Auth(..))
import Messages exposing (Msg(..), AuthMsg(..))
import Models.Main exposing (Model)
import Html.CssHelpers
import Styles


{ class } =
    Html.CssHelpers.withNamespace ""


view : Model -> Html AuthMsg
view model =
    case model.auth of
        NotAuthenticated ->
            div
                [ class [ Styles.Auth ] ]
                [ div [ onClick InitiateLogin ] [ text "Log in" ]
                , div [ onClick InitiateSignup ] [ text "Sign up" ]
                ]

        LoginFillout email pass ->
            div
                [ class [ Styles.Auth ]
                ]
                [ h2 [] [ text "Log in" ]
                , form
                    [ onSubmit SubmitLogin
                    ]
                    [ label []
                        [ text "User name"
                        , input
                            [ onInput ChangeLoginEmail
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ onInput ChangeLoginPassword
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

        LoginError err ->
            div
                [ class [ Styles.Auth ]
                ]
                [ h2 [] [ text "Login error" ]
                , p [] [ text err ]
                , p [ onClick InitiateLogin ] [ text "Try again" ]
                ]

        SignupFillout email pass ->
            div [ class [ Styles.Auth ] ]
                [ h2 [] [ text "Sign up" ]
                , form [ onSubmit SubmitSignup ]
                    [ label []
                        [ text "User name"
                        , input
                            [ onInput ChangeSignupEmail
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ onInput ChangeSignupPassword
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

        SignupError err ->
            div [ class [ Styles.Auth ] ]
                [ h2 [] [ text "Signup error" ]
                , p [] [ text err ]
                , p [ onClick InitiateSignup ] [ text "Try again" ]
                ]

        LoginPending email ->
            div
                [ class [ Styles.Auth ]
                ]
                [ text ("Hang in there while we log you in..")
                ]

        SignupPending email ->
            div
                [ class [ Styles.Auth ]
                ]
                [ text ("Hang in there while we sign you up..") ]

        LogoutPending ->
            div
                [ class [ Styles.Auth ]
                ]
                [ text ("Hang in there while we log you out..") ]

        Authenticated email ->
            div
                [ class [ Styles.Auth ]
                ]
                [ text ("Hello, " ++ email)
                , div [ onClick InitiateLogout ] [ text "Log out" ]
                ]
