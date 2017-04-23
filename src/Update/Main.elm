module Update.Main exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Models.Main exposing (Model)
import Update.Auth


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChange newRoute ->
            ( { model | route = newRoute }, Cmd.none )

        Navigate newUrl ->
            ( model, Navigation.newUrl newUrl )

        AuthMsg authMsg ->
            Update.Auth.update authMsg model

        NoOp ->
            ( model, Cmd.none )
