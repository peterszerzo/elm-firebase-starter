module Update.MyProfile exposing (..)

import Dict
import Commands
import Json.Decode as JD
import Models exposing (Model)
import Models.MyProfile
import Models.Auth exposing (Auth(..))
import Messages
import Messages.MyProfile exposing (Msg(..))


update : Messages.MyProfile.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case ( msg, model.myProfile, model.auth ) of
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
                ( { model | myProfile = Models.MyProfile.Saved data }, Cmd.none )

        ( EditField fieldId fieldValue, Models.MyProfile.Saved data, _ ) ->
            ( { model | myProfile = Models.MyProfile.UnsavedChanges (Dict.insert fieldId fieldValue data) }, Cmd.none )

        ( EditField fieldId fieldValue, Models.MyProfile.UnsavedChanges data, _ ) ->
            ( { model | myProfile = Models.MyProfile.UnsavedChanges (Dict.insert fieldId fieldValue data) }, Cmd.none )

        ( EditField fieldId fieldValue, _, _ ) ->
            ( model, Cmd.none )

        ( Save, Models.MyProfile.UnsavedChanges data, Authenticated user ) ->
            ( { model | myProfile = Models.MyProfile.Saving data }, Commands.saveProfile user.uid data )

        ( Save, _, _ ) ->
            -- Impossible state
            ( model, Cmd.none )

        ( SaveSuccess, Models.MyProfile.Saving data, _ ) ->
            ( { model | myProfile = Models.MyProfile.Saved data }, Cmd.none )

        ( SaveSuccess, _, _ ) ->
            -- Impossible state
            ( model, Cmd.none )

        ( UploadProfileImage fileInputFieldId, _, Authenticated user ) ->
            ( model, Commands.uploadProfileImage fileInputFieldId user.uid )

        ( UploadProfileImage fileInputFieldId, _, _ ) ->
            -- Impossible state
            ( model, Cmd.none )

        ( ProfileImageUploaded data, _, _ ) ->
            let
                _ =
                    Debug.log "data" data
            in
                ( model, Cmd.none )
