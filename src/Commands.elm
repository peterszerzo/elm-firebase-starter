module Commands exposing (..)

import Json.Encode as JE
import Ports


login : String -> String -> Cmd msg
login email pass =
    JE.object
        [ ( "type", JE.string "login" )
        , ( "payload"
          , JE.object
                [ ( "email", JE.string email ), ( "pass", JE.string pass ) ]
          )
        ]
        |> Ports.outgoing


signup : String -> String -> Cmd msg
signup email pass =
    JE.object
        [ ( "type", JE.string "signup" )
        , ( "payload"
          , JE.object
                [ ( "email", JE.string email ), ( "pass", JE.string pass ) ]
          )
        ]
        |> Ports.outgoing


logout : Cmd msg
logout =
    JE.object
        [ ( "type", JE.string "logout" ) ]
        |> Ports.outgoing
