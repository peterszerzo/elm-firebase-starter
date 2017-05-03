module Models.User exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias User =
    { uid : String
    , email : String
    }


encoder : User -> JE.Value
encoder user =
    JE.object
        [ ( "uid", JE.string user.uid )
        , ( "email", JE.string user.email )
        ]


decoder : JD.Decoder User
decoder =
    JD.map2 User
        (JD.field "uid" JD.string)
        (JD.field "email" JD.string)
