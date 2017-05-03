module Views.Auth exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p, a)
import Html.Attributes exposing (type_, href)
import Html.Events exposing (onClick, onInput, onSubmit)
import Models exposing (Model)
import Models.Auth exposing (Auth(..))
import Messages exposing (Msg(AuthMsg, Navigate))
import Messages.Auth exposing (Msg(..))
import Views.Auth.Styles exposing (CssClasses(..), localClass)


view : Model -> Html Messages.Msg
view model =
    div [ localClass [ Root ] ] <|
        case model.auth of
            NotAuthenticated ->
                [ div [ onClick (AuthMsg InitiateLogin) ] [ text "Log in" ]
                , div [ onClick (AuthMsg InitiateSignup) ] [ text "Sign up" ]
                ]

            LoginFillout email pass ->
                [ h2 [] [ text "Log in" ]
                , form
                    [ onSubmit (AuthMsg SubmitLogin)
                    ]
                    [ label []
                        [ text "User name"
                        , input
                            [ onInput (AuthMsg << ChangeLoginEmail)
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ onInput (AuthMsg << ChangeLoginPassword)
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

            LoginError err ->
                [ h2 [] [ text "Login error" ]
                , p [] [ text err ]
                , p [ onClick (AuthMsg InitiateLogin) ] [ text "Try again" ]
                ]

            SignupFillout email pass ->
                [ h2 [] [ text "Sign up" ]
                , form [ onSubmit (AuthMsg SubmitSignup) ]
                    [ label []
                        [ text "User name"
                        , input
                            [ onInput (AuthMsg << ChangeSignupEmail)
                            ]
                            []
                        ]
                    , label []
                        [ text "Password"
                        , input
                            [ onInput (AuthMsg << ChangeSignupPassword)
                            , type_ "password"
                            ]
                            []
                        ]
                    , input [ type_ "submit" ] []
                    ]
                ]

            SignupError err ->
                [ h2 [] [ text "Signup error" ]
                , p [] [ text err ]
                , p [ onClick (AuthMsg InitiateSignup) ] [ text "Try again" ]
                ]

            LoginPending email ->
                [ text ("Hang in there while we log you in..")
                ]

            SignupPending email ->
                [ text ("Hang in there while we sign you up..") ]

            LogoutPending ->
                [ text ("Hang in there while we log you out..") ]

            Authenticated { email } ->
                [ text ("Hello, " ++ email)
                , div [ onClick (AuthMsg InitiateLogout) ] [ text "Log out" ]
                , a [ href "javascript:void(0)", onClick (Navigate "/i") ] [ text "My profile" ]
                ]
