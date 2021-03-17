module Api.Graphql exposing (mutation, query)

import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)
import Session.Shared exposing (Shared)


withAuthToken : Maybe String -> Graphql.Http.Request decodesTo -> Graphql.Http.Request decodesTo
withAuthToken authToken =
    case authToken of
        Just t ->
            Graphql.Http.withHeader "authorization"
                ("Bearer " ++ t)

        Nothing ->
            identity


query : Shared -> Maybe String -> SelectionSet a RootQuery -> (RemoteData (Graphql.Http.Error a) a -> msg) -> Cmd msg
query { endpoints } maybeAuthToken query_ toMsg =
    query_
        |> Graphql.Http.queryRequest endpoints.graphql
        |> withAuthToken maybeAuthToken
        |> Graphql.Http.send (RemoteData.fromResult >> toMsg)


mutation : Shared -> Maybe String -> SelectionSet a RootMutation -> (RemoteData (Graphql.Http.Error a) a -> msg) -> Cmd msg
mutation { endpoints } maybeAuthToken mutation_ toMsg =
    mutation_
        |> Graphql.Http.mutationRequest endpoints.graphql
        |> withAuthToken maybeAuthToken
        |> Graphql.Http.send (RemoteData.fromResult >> toMsg)
