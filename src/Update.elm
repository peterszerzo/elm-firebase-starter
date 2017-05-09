module Update exposing (..)

import Navigation
import Commands
import Router
import Messages exposing (Msg(..))
import Models.Auth
import Models exposing (Model)
import Update.Auth
import Update.MyProfile


cmdOnRouteChange : Model -> Router.Route -> Cmd Msg
cmdOnRouteChange model newRoute =
    case ( model.auth, newRoute ) of
        ( Models.Auth.Authenticated auth, Router.MyProfile _ ) ->
            Commands.fetchProfile auth.uid

        ( _, _ ) ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.route ) of
        ( RouteChange newRoute, _ ) ->
            ( { model | route = newRoute }
            , cmdOnRouteChange model newRoute
            )

        ( Navigate newUrl, _ ) ->
            ( model, Navigation.newUrl newUrl )

        ( AuthMsg authMsg, _ ) ->
            Update.Auth.update authMsg model

        ( MyProfileMsg myProfileMsg, Router.MyProfile myProfile ) ->
            let
                ( newMyProfile, cmd ) =
                    Update.MyProfile.update model.auth myProfileMsg myProfile
            in
                ( { model | route = Router.MyProfile newMyProfile }, cmd )

        ( MyProfileMsg myProfileMsg, _ ) ->
            -- Impossible state
            ( model, Cmd.none )

        ( NoOp, _ ) ->
            ( model, Cmd.none )
