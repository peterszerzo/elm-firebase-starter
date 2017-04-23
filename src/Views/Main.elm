module Views.Main exposing (..)

import Html exposing (Html, program, div, text, node, h1)
import Messages exposing (Msg(..))
import Models.Main exposing (Model)
import Views.Auth
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
        , Views.Auth.view model
        ]
