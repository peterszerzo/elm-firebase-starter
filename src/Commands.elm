module Commands exposing (..)

import Json.Encode as JE
import Ports


login : String -> String -> Cmd msg
login user pass =
    JE.object
        [ ( "type", JE.string "login" )
        , ( "payload"
          , JE.object
                [ ( "user", JE.string user ), ( "pass", JE.string pass ) ]
          )
        ]
        |> Ports.outgoing


signup : String -> String -> Cmd msg
signup user pass =
    JE.object
        [ ( "type", JE.string "signup" )
        , ( "payload"
          , JE.object
                [ ( "user", JE.string user ), ( "pass", JE.string pass ) ]
          )
        ]
        |> Ports.outgoing


logout : Cmd msg
logout =
    JE.object
        [ ( "type", JE.string "logout" ) ]
        |> Ports.outgoing
