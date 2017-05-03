module Views.MyProfile.Styles exposing (..)

import Html
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)


cssNamespace : String
cssNamespace =
    "myprofile"


type CssClasses
    = Root


localClass : List class -> Html.Attribute msg
localClass =
    Html.CssHelpers.withNamespace cssNamespace |> .class


styles : List Css.Snippet
styles =
    [ Css.class Root
        [ width (px 600)
        , paddingTop (px 100)
        , margin auto
        ]
    ]
        |> namespace cssNamespace
