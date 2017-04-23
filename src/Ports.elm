port module Ports exposing (..)

import Json.Encode as JE
import Json.Decode as JD


port outgoing : JE.Value -> Cmd msg


port incoming : (JD.Value -> msg) -> Sub msg
