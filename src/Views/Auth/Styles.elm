module Views.Auth.Styles exposing (..)

import Html
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)


cssNamespace : String
cssNamespace =
    "auth"


type CssClasses
    = Root


localClass : List class -> Html.Attribute msg
localClass =
    Html.CssHelpers.withNamespace cssNamespace |> .class


styles : List Css.Snippet
styles =
    [ Css.class Root
        [ position fixed
        , top (px 90)
        , right (px 30)
        , width (px 300)
        , padding (px 20)
        , property "border" "1px solid #ddd"
        ]
    ]
        |> namespace cssNamespace
