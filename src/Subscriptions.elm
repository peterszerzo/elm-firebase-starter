module Subscriptions exposing (..)

import Dict
import Ports
import Json.Decode as JD
import Messages exposing (Msg(..))


type alias IncomingMessage =
    { type_ : String
    , payload : Dict.Dict String String
    }


decoder : JD.Decoder IncomingMessage
decoder =
    JD.map2 IncomingMessage
        (JD.field "type" JD.string)
        (JD.field "payload" (JD.dict JD.string))


subscriptions : model -> Sub Msg
subscriptions model =
    Ports.incoming
        (\val ->
            val
                |> JD.decodeValue decoder
                |> Result.toMaybe
                |> Maybe.map
                    (\{ type_, payload } ->
                        case type_ of
                            "login" ->
                                AuthStateChange
                                    (Dict.get "user" payload)

                            "logout" ->
                                AuthStateChange Nothing

                            "loginerror" ->
                                UnsuccessfulLogin
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "signuperror" ->
                                UnsuccessfulSignup
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            _ ->
                                NoOp
                    )
                |> Maybe.withDefault NoOp
        )
