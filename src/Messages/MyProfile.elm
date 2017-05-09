module Messages.MyProfile exposing (..)

import Dict


type Msg
    = ReceiveData (Dict.Dict String String)
    | EditField String String
    | Save
    | SaveSuccess
