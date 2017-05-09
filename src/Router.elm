module Router exposing (..)

import Navigation
import UrlParser exposing (..)
import Models.MyProfile


type Route
    = Home
    | MyProfile Models.MyProfile.MyProfile
    | NotFound


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ s "" |> map Home
        , s "i" |> map (MyProfile Models.MyProfile.init)
        ]


parse : Navigation.Location -> Route
parse location =
    location
        |> UrlParser.parsePath matchers
        |> Maybe.withDefault NotFound
