module Router exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = Home
    | MyProfile
    | NotFound


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ s "" |> map Home
        , s "i" |> map MyProfile
          -- Dynamic url fragment example
          -- , s "profile"
          --     </> string
          --     |> map (\profileId -> Profile profileId)
        ]


parse : Navigation.Location -> Route
parse location =
    location
        |> UrlParser.parsePath matchers
        |> Maybe.withDefault NotFound
