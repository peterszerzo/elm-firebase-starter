#!/bin/sh

touch src/Views/$1.elm
mkdir src/Views/$1
touch src/Views/$1/Styles.elm

cat > src/Views/$1.elm << EOL
module Views.$1 exposing (..)

import Html exposing (Html, div, h2, p, a, text)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Views.$1.Styles exposing (CssClasses(..), localClass)


view : Model -> Html Msg
view model =
    div [ localClass [ Root ] ]
        [ h2 [] [ text "$1" ]
        ]
EOL

cat > src/Views/$1/Styles.elm << EOL
module Views.$1.Styles exposing (..)

import Html
import Html.CssHelpers
import Css exposing (..)
import Css.Elements exposing (a)
import Css.Namespace exposing (namespace)
import Styles.Mixins as Mixins


cssNamespace : String
cssNamespace =
    "$1"


type CssClasses
    = Root


localClass : List class -> Html.Attribute msg
localClass =
    Html.CssHelpers.withNamespace cssNamespace |> .class


localClassList : List ( class, Bool ) -> Html.Attribute msg
localClassList =
    Html.CssHelpers.withNamespace cssNamespace |> .classList


styles : List Css.Snippet
styles =
    [ Css.class Root []
    ]
        |> namespace cssNamespace
EOL
