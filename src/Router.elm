module Router exposing (..)

import Navigation
import UrlParser exposing (..)
import Page.MyProfile


type Route
    = Home
    | MyProfile Page.MyProfile.Model
    | NotFound


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ s "" |> map Home
        , s "i" |> map (MyProfile Page.MyProfile.init)
        ]


parse : Navigation.Location -> Route
parse location =
    location
        |> UrlParser.parsePath matchers
        |> Maybe.withDefault NotFound
