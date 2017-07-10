module Page.MyProfile exposing (..)

import Dict
import Json.Encode as JE
import Json.Decode as JD
import Html exposing (Html, program, text, div, h1, h2, h3, form, label, input, p, button)
import Html.Attributes exposing (type_, id, for, value)
import Html.Events exposing (onInput, onClick, on)
import Data.Auth exposing (Auth(..))
import Commands
import Page.MyProfile.Styles exposing (localClass, CssClasses(..))


-- Model


type alias ProfileData =
    Dict.Dict String String


type Model
    = NotAvailable
    | Saved ProfileData
    | UnsavedChanges ProfileData
    | Saving ProfileData
    | SaveError ProfileData String


init : Model
init =
    NotAvailable



-- Update


type Msg
    = ReceiveData (Dict.Dict String String)
    | EditField String String
    | Save
    | SaveSuccess


update :
    Auth
    -> Msg
    -> Model
    -> ( Model, Maybe JE.Value )
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
                ( Saved data, Nothing )

        ( EditField fieldId fieldValue, Saved data, _ ) ->
            ( UnsavedChanges (Dict.insert fieldId fieldValue data), Nothing )

        ( EditField fieldId fieldValue, UnsavedChanges data, _ ) ->
            ( UnsavedChanges (Dict.insert fieldId fieldValue data), Nothing )

        ( EditField fieldId fieldValue, _, _ ) ->
            ( myProfile, Nothing )

        ( Save, UnsavedChanges data, Authenticated user ) ->
            ( Saving data, Commands.saveProfile user.uid data |> Just )

        ( Save, _, _ ) ->
            -- Impossible state
            ( myProfile, Nothing )

        ( SaveSuccess, Saving data, _ ) ->
            ( Saved data, Nothing )

        ( SaveSuccess, _, _ ) ->
            -- Impossible state
            ( myProfile, Nothing )



-- View


fileInputFieldId : String
fileInputFieldId =
    "myprofileimage"


fields : List { id : String, label : String }
fields =
    [ { id = "name", label = "Name" }
    , { id = "description", label = "Description" }
    ]


viewForm : Dict.Dict String String -> Html Msg
viewForm data =
    form []
        (List.map
            (\field ->
                label [ for field.id ]
                    [ p [] [ text field.label ]
                    , input
                        [ id field.id
                        , value (Dict.get field.id data |> Maybe.withDefault "")
                        , onInput (\val -> EditField field.id val)
                        ]
                        []
                    ]
            )
            fields
        )


view : Model -> Html Msg
view myProfile =
    div [ localClass [ Root ] ]
        [ h2 [] [ text "My profile" ]
        , div [ localClass [ Section ] ]
            [ h3 []
                [ text "Profile"
                , div [] <|
                    case myProfile of
                        NotAvailable ->
                            [ p [] [ text "Loading.." ] ]

                        Saved data ->
                            [ viewForm data ]

                        Saving data ->
                            [ p [] [ text "Saving.." ] ]

                        UnsavedChanges data ->
                            [ viewForm data
                            , button [ onClick Save ] [ text "Save" ]
                            ]

                        _ ->
                            [ p [] [ text "View not implemented" ] ]
                ]
            ]
        ]
