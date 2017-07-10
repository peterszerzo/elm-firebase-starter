module Page.MyProfile.Styles exposing (..)

import Html
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)


cssNamespace : String
cssNamespace =
    "myprofile"


type CssClasses
    = Root
    | Section


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
    , Css.class Section
        [ padding (px 20)
        , margin2 (px 20) (px 0)
        , property "background-color" "#ededef"
        ]
    ]
        |> namespace cssNamespace
