module Views exposing (..)

import Html exposing (Html, map, program, div, text, node, h1, p)
import Messages exposing (Msg(..))
import Router
import Models exposing (Model)
import Views.Auth
import Views.MyProfile
import Css.File exposing (compile)
import Styles exposing (css)


view : Model -> Html Msg
view model =
    div []
        [ node "style"
            []
            [ if model.isDevelopment then
                compile [ css ] |> .css |> text
              else
                text ""
            ]
        , h1 []
            [ text "elm-firebase-starter"
            ]
        , Views.Auth.view model |> map AuthMsg
        , case model.route of
            Router.MyProfile ->
                Views.MyProfile.view model |> map MyProfileMsg

            _ ->
                div [] []
        ]
