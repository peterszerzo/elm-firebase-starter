module Update.MyProfile exposing (..)

import Dict
import Commands
import Json.Decode as JD
import Models.MyProfile
import Models.Auth exposing (Auth(..))
import Messages
import Messages.MyProfile exposing (Msg(..))


update :
    Auth
    -> Messages.MyProfile.Msg
    -> Models.MyProfile.MyProfile
    -> ( Models.MyProfile.MyProfile, Cmd Messages.Msg )
update auth msg myProfile =
    case ( msg, myProfile, auth ) of
        ( ReceiveData profile, _, _ ) ->
            let
                data =
                    profile
                        |> Dict.get "data"
                        |> Maybe.andThen
                            (\data ->
                                JD.decodeString (JD.dict JD.string) data
                                    |> Result.toMaybe
                            )
                        |> Maybe.withDefault Dict.empty
            in
                ( Models.MyProfile.Saved data, Cmd.none )

        ( EditField fieldId fieldValue, Models.MyProfile.Saved data, _ ) ->
            ( Models.MyProfile.UnsavedChanges (Dict.insert fieldId fieldValue data), Cmd.none )

        ( EditField fieldId fieldValue, Models.MyProfile.UnsavedChanges data, _ ) ->
            ( Models.MyProfile.UnsavedChanges (Dict.insert fieldId fieldValue data), Cmd.none )

        ( EditField fieldId fieldValue, _, _ ) ->
            ( myProfile, Cmd.none )

        ( Save, Models.MyProfile.UnsavedChanges data, Authenticated user ) ->
            ( Models.MyProfile.Saving data, Commands.saveProfile user.uid data )

        ( Save, _, _ ) ->
            -- Impossible state
            ( myProfile, Cmd.none )

        ( SaveSuccess, Models.MyProfile.Saving data, _ ) ->
            ( Models.MyProfile.Saved data, Cmd.none )

        ( SaveSuccess, _, _ ) ->
            -- Impossible state
            ( myProfile, Cmd.none )
