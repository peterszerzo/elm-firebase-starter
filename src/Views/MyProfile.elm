module Views.MyProfile exposing (..)

import Dict
import Json.Decode as JD
import Html exposing (Html, program, text, div, h1, h2, h3, form, label, input, p, button)
import Html.Attributes exposing (type_, id, for, value)
import Html.Events exposing (onInput, onClick, on)
import Views.MyProfile.Styles exposing (CssClasses(..), localClass)
import Models exposing (Model)
import Models.MyProfile exposing (MyProfile(..))
import Messages.MyProfile exposing (Msg(..))


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
view model =
    div [ localClass [ Root ] ]
        [ h2 [] [ text "My profile" ]
        , div [ localClass [ Section ] ]
            [ h3 []
                [ text "Profile"
                , div [] <|
                    case model.myProfile of
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
        , div [ localClass [ Section ] ]
            [ h3 [] [ text "Image" ]
            , label [ for fileInputFieldId ]
                [ p [] [ text "Upload" ]
                , input
                    [ type_ "file"
                    , id fileInputFieldId
                    , on "change" (UploadProfileImage fileInputFieldId |> JD.succeed)
                    ]
                    []
                ]
            ]
        ]
