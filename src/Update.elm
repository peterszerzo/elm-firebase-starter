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
        ( Models.Auth.Authenticated auth, Router.MyProfile ) ->
            Commands.fetchProfile auth.uid

        ( _, _ ) ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChange newRoute ->
            ( { model | route = newRoute }
            , cmdOnRouteChange model newRoute
            )

        Navigate newUrl ->
            ( model, Navigation.newUrl newUrl )

        AuthMsg authMsg ->
            Update.Auth.update authMsg model

        MyProfileMsg myProfileMsg ->
            Update.MyProfile.update myProfileMsg model

        NoOp ->
            ( model, Cmd.none )
