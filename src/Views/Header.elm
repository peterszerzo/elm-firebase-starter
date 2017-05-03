module Views.Header exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, a)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Views.Header.Styles exposing (CssClasses(..), localClass)


view : Model -> Html Msg
view model =
    div [ localClass [ Root ] ]
        [ a
            [ localClass [ HomeLink ]
            , href "javascript:void(0)"
            , onClick (Navigate "/")
            ]
            [ text "elm-firebase-starter" ]
        ]
