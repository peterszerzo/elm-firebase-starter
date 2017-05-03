module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (h1, html, body, input, label)
import Css.Namespace exposing (namespace)
import Views.Auth.Styles
import Views.MyProfile.Styles
import Views.Header.Styles
import Views.Home.Styles


css : Stylesheet
css =
    (stylesheet << namespace "")
        ([ everything
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
         , input
            [ display block
            , marginTop (px 6)
            , width (pct 100)
            , padding (px 4)
            , outline none
            , boxShadow none
            , property "border" "1px solid #eee"
            ]
         , label
            [ display block
            , margin2 (px 10) (px 0)
            ]
         ]
            ++ Views.Auth.Styles.styles
            ++ Views.MyProfile.Styles.styles
            ++ Views.Header.Styles.styles
            ++ Views.Home.Styles.styles
        )
