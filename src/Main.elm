module Main exposing (..)

import Navigation exposing (programWithFlags)
import Router
import Css
import Html exposing (Html, map, program, div, text, node, h1, p)
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Data.Auth exposing (Auth(..))
import Views.Header
import Views.Auth
import Page.Home
import Commands
import Styles
import Ports
import Update.Auth
import Page.MyProfile


-- Model


type alias Flags =
    Bool


type alias Model =
    { auth : Auth
    , isDevelopment : Bool
    , route : Router.Route
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init isDevelopment location =
    let
        route =
            Router.parse location

        model =
            { auth = NotAuthenticated
            , isDevelopment = isDevelopment
            , route = route
            }
    in
        ( model
        , cmdOnRouteChange model route
        )



-- Update


cmdOnRouteChange : Model -> Router.Route -> Cmd Msg
cmdOnRouteChange model newRoute =
    case ( model.auth, newRoute ) of
        ( Data.Auth.Authenticated auth, Router.MyProfile _ ) ->
            Commands.fetchProfile auth.uid |> Ports.outgoing

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

        ( AuthChange authMsg, _ ) ->
            let
                ( newAuth, cmdValue ) =
                    Update.Auth.update model.route authMsg model.auth
            in
                ( { model | auth = newAuth }, cmdValue |> Maybe.map Ports.outgoing |> Maybe.withDefault Cmd.none )

        ( MyProfileChange myProfileMsg, Router.MyProfile myProfile ) ->
            let
                ( newMyProfile, cmdValue ) =
                    Page.MyProfile.update model.auth myProfileMsg myProfile
            in
                ( { model | route = Router.MyProfile newMyProfile }
                , cmdValue
                    |> Maybe.map Ports.outgoing
                    |> Maybe.withDefault Cmd.none
                )

        ( MyProfileChange myProfileMsg, _ ) ->
            -- Impossible state
            ( model, Cmd.none )

        ( NoOp, _ ) ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ node "style"
            []
            [ if model.isDevelopment then
                Css.compile [ Styles.css ] |> .css |> text
              else
                text ""
            ]
        , Views.Header.view
        , Views.Auth.view model.auth
        , case model.route of
            Router.Home ->
                Page.Home.view

            Router.MyProfile myProfile ->
                Page.MyProfile.view myProfile |> map MyProfileChange

            _ ->
                div [] []
        ]



-- Main


main : Program Flags Model Msg
main =
    programWithFlags (RouteChange << Router.parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
