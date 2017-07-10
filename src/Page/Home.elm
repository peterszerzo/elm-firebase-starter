module Page.Home exposing (..)

import Html exposing (Html, program, text, div, h1, h2, form, label, input, p)
import Page.Home.Styles exposing (CssClasses(..), localClass)


view : Html msg
view =
    div [ localClass [ Root ] ]
        [ h1 [] [ text "elm-firebase-starter" ]
        ]
