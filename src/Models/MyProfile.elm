module Models.MyProfile exposing (..)

import Dict


type alias ProfileData =
    Dict.Dict String String


type MyProfile
    = NotAvailable
    | Saved ProfileData
    | UnsavedChanges ProfileData
    | Saving ProfileData
    | SaveError ProfileData String
