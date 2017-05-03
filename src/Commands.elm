module Commands exposing (..)

import Dict
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


fetchProfile : String -> Cmd msg
fetchProfile uid =
    JE.object
        [ ( "type", JE.string "fetchprofile" )
        , ( "payload", JE.object [ ( "uid", JE.string uid ) ] )
        ]
        |> Ports.outgoing


saveProfile : String -> Dict.Dict String String -> Cmd msg
saveProfile uid data =
    JE.object
        [ ( "type", JE.string "saveprofile" )
        , ( "payload"
          , JE.object
                [ ( "uid", JE.string uid )
                , ( "data"
                  , data
                        |> Dict.toList
                        |> List.map (\( key, value ) -> ( key, JE.string value ))
                        |> JE.object
                  )
                ]
          )
        ]
        |> Ports.outgoing


uploadProfileImage : String -> String -> Cmd msg
uploadProfileImage fileInputFieldId uid =
    JE.object
        [ ( "type", JE.string "uploadprofileimage" )
        , ( "payload"
          , JE.object
                [ ( "fileInputFieldId", JE.string fileInputFieldId )
                , ( "uid", JE.string uid )
                ]
          )
        ]
        |> Ports.outgoing
