module Views.MyProfile exposing (..)

import Dict
import Html exposing (Html, program, text, div, h1, h2, form, label, input, p, button)
import Html.Attributes exposing (id, for, value)
import Html.Events exposing (onInput, onClick)
import Views.MyProfile.Styles exposing (CssClasses(..), localClass)
import Models exposing (Model)
import Models.MyProfile exposing (MyProfile(..))
import Messages.MyProfile exposing (Msg(..))


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
