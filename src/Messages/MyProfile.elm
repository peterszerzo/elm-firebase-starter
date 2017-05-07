module Messages.MyProfile exposing (..)

import Dict


type Msg
    = ReceiveData (Dict.Dict String String)
    | EditField String String
    | Save
    | SaveSuccess
    | UploadProfileImage String
    | ProfileImageUploaded (Dict.Dict String String)
    | ProfileImageUrlReceived (Dict.Dict String String)
