module Commands exposing (..)

import Dict
import Json.Encode as JE


login : String -> String -> JE.Value
login email pass =
    JE.object
        [ ( "type", JE.string "login" )
        , ( "payload"
          , JE.object
                [ ( "email", JE.string email ), ( "pass", JE.string pass ) ]
          )
        ]


signup : String -> String -> JE.Value
signup email pass =
    JE.object
        [ ( "type", JE.string "signup" )
        , ( "payload"
          , JE.object
                [ ( "email", JE.string email ), ( "pass", JE.string pass ) ]
          )
        ]


logout : JE.Value
logout =
    JE.object
        [ ( "type", JE.string "logout" ) ]


fetchProfile : String -> JE.Value
fetchProfile uid =
    JE.object
        [ ( "type", JE.string "fetch:profile" )
        , ( "payload", JE.object [ ( "uid", JE.string uid ) ] )
        ]


saveProfile : String -> Dict.Dict String String -> JE.Value
saveProfile uid data =
    JE.object
        [ ( "type", JE.string "save:profile" )
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
