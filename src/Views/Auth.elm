module Views.Auth exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p, a, span)
import Html.Attributes exposing (type_, href)
import Html.Events exposing (onClick, onInput, onSubmit)
import Data.Auth exposing (Auth(..))
import Messages exposing (Msg(AuthChange, Navigate), AuthMsg(..))
import Views.Auth.Styles exposing (CssClasses(..), localClass)


view : Auth -> Html Messages.Msg
view auth =
    div [ localClass [ Root ] ] <|
        [ div []
            [ span [ onClick (AuthChange InitiateLogin) ] [ text "Log in" ]
            , span [] [ text " | " ]
            , span [ onClick (AuthChange InitiateSignup) ] [ text "Sign up" ]
            ]
        ]
            ++ (case auth of
                    NotAuthenticated ->
                        []

                    LoginFillout email pass ->
                        [ h2 [] [ text "Log in" ]
                        , form
                            [ onSubmit (AuthChange SubmitLogin)
                            ]
                            [ label []
                                [ text "User name"
                                , input
                                    [ onInput (AuthChange << ChangeLoginEmail)
                                    ]
                                    []
                                ]
                            , label []
                                [ text "Password"
                                , input
                                    [ onInput (AuthChange << ChangeLoginPassword)
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
                        , p [ onClick (AuthChange InitiateLogin) ] [ text "Try again" ]
                        ]

                    SignupFillout email pass ->
                        [ h2 [] [ text "Sign up" ]
                        , form [ onSubmit (AuthChange SubmitSignup) ]
                            [ label []
                                [ text "User name"
                                , input
                                    [ onInput (AuthChange << ChangeSignupEmail)
                                    ]
                                    []
                                ]
                            , label []
                                [ text "Password"
                                , input
                                    [ onInput (AuthChange << ChangeSignupPassword)
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
                        , p [ onClick (AuthChange InitiateSignup) ] [ text "Try again" ]
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
                        , div [ onClick (AuthChange InitiateLogout) ] [ text "Log out" ]
                        , a [ href "javascript:void(0)", onClick (Navigate "/i") ] [ text "My profile" ]
                        ]
               )
