module Views.Header.Styles exposing (..)

import Html
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)


cssNamespace : String
cssNamespace =
    "header"


type CssClasses
    = Root
    | HomeLink


localClass : List class -> Html.Attribute msg
localClass =
    Html.CssHelpers.withNamespace cssNamespace |> .class


styles : List Css.Snippet
styles =
    [ Css.class Root
        [ width (pct 100)
        , height (px 60)
        , position fixed
        , top (px 0)
        , left (px 0)
        , property "background-color" "#eee"
        ]
    , Css.class HomeLink
        [ position absolute
        , top (pct 50)
        , left (px 30)
        , transform (translate3d (px 0) (pct -50) (px 0))
        , margin (px 0)
        , textDecoration none
        , color inherit
        ]
    ]
        |> namespace cssNamespace
