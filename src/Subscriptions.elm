module Subscriptions exposing (..)

import Dict
import Ports
import Json.Decode as JD
import Messages exposing (Msg(..), AuthMsg(..))


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
                            "authstatechange" ->
                                (AuthMsg << AuthStateChange) payload

                            "loginerror" ->
                                (AuthMsg << UnsuccessfulLogin)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "signuperror" ->
                                (AuthMsg << UnsuccessfulSignup)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            _ ->
                                NoOp
                    )
                |> Maybe.withDefault NoOp
        )
