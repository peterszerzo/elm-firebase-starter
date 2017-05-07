module Subscriptions exposing (..)

import Dict
import Ports
import Json.Decode as JD
import Messages
import Messages.Auth
import Messages.MyProfile


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
                                (Messages.AuthMsg << Messages.Auth.AuthStateChange) payload

                            "login:error" ->
                                (Messages.AuthMsg << Messages.Auth.UnsuccessfulLogin)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "signup:error" ->
                                (Messages.AuthMsg << Messages.Auth.UnsuccessfulSignup)
                                    (Dict.get "message" payload
                                        |> Maybe.withDefault "Err"
                                    )

                            "profile" ->
                                (Messages.MyProfileMsg << Messages.MyProfile.ReceiveData)
                                    payload

                            "profile:saved" ->
                                Messages.MyProfileMsg Messages.MyProfile.SaveSuccess

                            "profile:image:uploaded" ->
                                (Messages.MyProfileMsg << Messages.MyProfile.ProfileImageUploaded) payload

                            "profile:image:url" ->
                                (Messages.MyProfileMsg << Messages.MyProfile.ProfileImageUrlReceived) payload

                            _ ->
                                Messages.NoOp
                    )
                |> Maybe.withDefault Messages.NoOp
        )
