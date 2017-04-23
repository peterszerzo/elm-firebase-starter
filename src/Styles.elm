module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (h1)
import Css.Namespace exposing (namespace)


type CssClasses
    = Background
    | Banner
    | BannerLogo


css : Stylesheet
css =
    (stylesheet << namespace "")
        [ everything
            [ boxSizing borderBox
            , property "font-family" "monospace"
            , property "-webkit-font-smoothing" "antialiased"
            , property "-moz-osx-font-smoothing" "grayscale"
            ]
        , h1
            [ property "color" "red"
            ]
        ]
