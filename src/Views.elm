module Views exposing (..)

import Html exposing (Html, map, program, div, text, node, h1, p)
import Messages exposing (Msg(..))
import Router
import Models exposing (Model)
import Views.Auth
import Views.Home
import Views.MyProfile
import Views.Header
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
        , Views.Header.view model
        , Views.Auth.view model
        , case model.route of
            Router.Home ->
                Views.Home.view

            Router.MyProfile myProfile ->
                Views.MyProfile.view myProfile |> map MyProfileMsg

            _ ->
                div [] []
        ]
