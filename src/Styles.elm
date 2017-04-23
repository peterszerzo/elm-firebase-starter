module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (h1, html, body, input, label)
import Css.Namespace exposing (namespace)


type CssClasses
    = Auth


css : Stylesheet
css =
    (stylesheet << namespace "")
        [ everything
            [ boxSizing borderBox
            , property "font-family" "monospace"
            , property "-webkit-font-smoothing" "antialiased"
            , property "-moz-osx-font-smoothing" "grayscale"
            ]
        , each [ html, body ]
            [ padding (px 0)
            , margin (px 0)
            , width (pct 100)
            , height (pct 100)
            ]
        , body
            [ position relative
            ]
        , h1
            [ property "color" "red"
            ]
        , class Auth
            [ position fixed
            , top (px 30)
            , right (px 30)
            , width (px 300)
            , padding (px 20)
            , property "border" "1px solid #ddd"
            ]
        , input
            [ display block
            , marginTop (px 6)
            , width (pct 100)
            , padding (px 4)
            , outline none
            , boxShadow none
            , property "border" "none"
            ]
        , label
            [ display block
            , margin2 (px 10) (px 0)
            ]
        ]
