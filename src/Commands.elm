module Commands exposing (..)

import Http
import Msgs exposing (Msg)
import Model exposing (Info)
import RemoteData
import Routing
import Model
import Navigation
import String.Interpolate exposing(interpolate)

fetchInfo: String -> Cmd Msg
fetchInfo id = 
    Http.get (interpolate "http://aws3.proteininformationresource.org/{0}/info" [id]) Model.infoDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Msgs.OnFetchInfo

fetchProteoforms: String -> Cmd Msg
fetchProteoforms id = 
    Http.get (interpolate "http://aws3.proteininformationresource.org/{0}/proteoforms" [id]) Model.proteoformListDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Msgs.OnFetchProteoform

handleRoute : Model.Model -> Navigation.Location -> (Model.Model, Cmd Msg)
handleRoute model location =
        -- parse to location to get the route and update the model       
        let
            currentRoute =
                Routing.parseLocation location
        in
        case currentRoute of 
            Routing.HomeRoute -> 
                (Model.initialModel currentRoute, Cmd.none )
            Routing.EntryRoute id ->
                (Model.initialModel currentRoute, Cmd.batch [fetchInfo id, fetchProteoforms id])
            Routing.NotFoundRoute ->
                (Model.initialModel currentRoute, Cmd.none )