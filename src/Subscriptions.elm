module Subscriptions exposing (..)

import Dict
import Ports
import Json.Decode as JD
import Messages
import Page.MyProfile


type alias IncomingMessage =
    { type_ : String
    , payload : Dict.Dict String String
    }


decoder : JD.Decoder IncomingMessage
decoder =
    JD.map2 IncomingMessage
        (JD.field "type" JD.string)
        (JD.field "payload" (JD.dict JD.string))


subscriptions : model -> Sub Messages.Msg
subscriptions model =
    Ports.incoming
        (\val ->
            val
                |> JD.decodeValue decoder
                |> Result.toMaybe
                |> Maybe.map
                    (\{ type_, payload } ->
                        case type_ of
                            "auth:state:change" ->
                                (Messages.AuthChange << Messages.AuthStateChange) payload

                            "login:error" ->
                                (Messages.AuthChange << Messages.UnsuccessfulLogin)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "signup:error" ->
                                (Messages.AuthChange << Messages.UnsuccessfulSignup)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "profile" ->
                                (Messages.MyProfileChange << Page.MyProfile.ReceiveData)
                                    payload

                            "profile:saved" ->
                                Messages.MyProfileChange Page.MyProfile.SaveSuccess

                            _ ->
                                Messages.NoOp
                    )
                |> Maybe.withDefault Messages.NoOp
        )
