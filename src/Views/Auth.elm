module Views.Auth exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p)
import Html.Attributes exposing (type_, autocomplete)
import Html.Events exposing (onClick, onInput, onSubmit)
import Models.Auth exposing (Auth(..))
import Messages exposing (Msg(..))
import Models.Main exposing (Model)


view : Model -> Html Msg
view model =
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
