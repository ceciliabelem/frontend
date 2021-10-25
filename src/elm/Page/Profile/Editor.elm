module Page.Profile.Editor exposing
    ( Model
    , Msg
    , init
    , msgToString
    , receiveBroadcast
    , subscriptions
    , update
    , view
    )

import Api
import Api.Graphql
import Avatar
import Dict
import File exposing (File)
import Graphql.Http
import Html exposing (Html, button, div, form, span, text)
import Html.Attributes exposing (class, disabled, id, style)
import Html.Events
import Http
import Icons
import Json.Decode
import Log
import Page
import Profile
import RemoteData exposing (RemoteData)
import Route
import Session.LoggedIn as LoggedIn exposing (External(..))
import Session.Shared exposing (Translators)
import UpdateResult as UR
import View.Feedback as Feedback
import View.Form.FileUploader as FileUploader
import View.Form.Input as Input
import View.MarkdownEditor as MarkdownEditor



-- INIT


init : LoggedIn.Model -> ( Model, Cmd Msg )
init loggedIn =
    ( initModel
    , LoggedIn.maybeInitWith CompletedLoadProfile .profile loggedIn
    )



-- MODEL


type alias Model =
    { fullName : String
    , email : String
    , bio : MarkdownEditor.Model
    , location : String
    , interests : List String
    , interest : String
    , avatar : RemoteData Http.Error String
    }


initModel : Model
initModel =
    { fullName = ""
    , email = ""
    , bio = MarkdownEditor.init "bio-editor"
    , location = ""
    , interests = []
    , interest = ""
    , avatar = RemoteData.Loading
    }



-- VIEW


view : LoggedIn.Model -> Model -> { title : String, content : Html Msg }
view loggedIn model =
    let
        { t } =
            loggedIn.shared.translators

        title =
            t "profile.edit.title"

        content =
            case loggedIn.profile of
                RemoteData.Loading ->
                    Page.fullPageLoading loggedIn.shared

                RemoteData.NotAsked ->
                    Page.fullPageLoading loggedIn.shared

                RemoteData.Failure e ->
                    Page.fullPageGraphQLError (t "profile.title") e

                RemoteData.Success profile ->
                    view_ loggedIn model profile
    in
    { title = title
    , content = content
    }


view_ : LoggedIn.Model -> Model -> Profile.Model -> Html Msg
view_ loggedIn model profile =
    let
        { t } =
            loggedIn.shared.translators

        translators =
            loggedIn.shared.translators

        title =
            t "menu.edit" ++ " " ++ ("menu.profile" |> t |> String.toLower)

        pageHeader =
            Page.viewHeader loggedIn title

        isFullNameDisabled =
            profile.communities |> List.any .hasKyc
    in
    div [ class "bg-white" ]
        [ pageHeader
        , form
            [ class "pt-4 container mx-auto p-4" ]
            [ viewAvatar translators model.avatar
            , viewInput translators isFullNameDisabled FullName model.fullName
            , viewInput translators False Email model.email
            , MarkdownEditor.view
                { translators = translators
                , placeholder = Nothing
                , label = t "profile.edit.labels.bio"
                , problem = Nothing
                , disabled = False
                }
                [ class "text-sm text-black" ]
                model.bio
                |> Html.map GotBioEditorMsg
            , viewInput translators False Location model.location
            , viewInput translators False Interest model.interest
            , viewInterests model.interests
            , viewButton (t "profile.edit.submit") ClickedSave "save" (RemoteData.isLoading loggedIn.profile)
            ]
        ]


viewInput : Translators -> Bool -> Field -> String -> Html Msg
viewInput translators isDisabled field currentValue =
    let
        ( label, id, modifications ) =
            case field of
                FullName ->
                    ( "profile.edit.labels.name", "name_input", identity )

                Email ->
                    ( "profile.edit.labels.email", "email_input", identity )

                Location ->
                    ( "profile.edit.labels.localization", "location_input", identity )

                Interest ->
                    ( "profile.edit.labels.interests"
                    , "interests_field"
                    , Input.withInputContainerAttrs [ class "flex" ]
                        >> Input.withElements
                            [ button
                                [ class "button-secondary px-4 h-12 align-bottom ml-4"
                                , onClickPreventDefault AddInterest
                                ]
                                [ text <| String.toUpper (translators.t "menu.add") ]
                            ]
                    )
    in
    Input.init
        { label = translators.t label
        , id = id
        , onInput = OnFieldInput field
        , disabled = isDisabled
        , value = currentValue
        , placeholder = Nothing
        , problems = Nothing
        , translators = translators
        }
        |> Input.withContainerAttrs [ class "mb-4" ]
        |> modifications
        |> Input.toHtml


viewInterests : List String -> Html Msg
viewInterests interests =
    let
        viewInterest interest =
            div [ class "bg-green px-3 h-8 rounded-sm text-sm mr-4 mb-1 flex" ]
                [ span [ class "m-auto mr-3 text-white uppercase" ] [ text interest ]
                , button
                    [ class "m-auto"
                    , onClickPreventDefault (RemoveInterest interest)
                    ]
                    [ Icons.close "w-4 h-4 text-white fill-current" ]
                ]
    in
    div [ class "flex flex-wrap mb-4" ]
        (List.map viewInterest interests)


onClickPreventDefault : msg -> Html.Attribute msg
onClickPreventDefault message =
    Html.Events.custom "click" (Json.Decode.succeed { message = message, stopPropagation = True, preventDefault = True })


viewButton : String -> Msg -> String -> Bool -> Html Msg
viewButton label msg area isDisabled =
    button
        [ class "button button-primary w-full"
        , class
            (if isDisabled then
                "button-disabled"

             else
                ""
            )
        , style "grid-area" area
        , onClickPreventDefault msg
        , disabled isDisabled
        ]
        [ text label
        ]


viewAvatar : Translators -> RemoteData Http.Error String -> Html Msg
viewAvatar translators avatar =
    FileUploader.init
        { label = ""
        , id = "profile-upload-avatar"
        , onFileInput = EnteredAvatar
        , status = avatar
        }
        |> FileUploader.withVariant FileUploader.Small
        |> FileUploader.toHtml translators



-- UPDATE


type Msg
    = CompletedLoadProfile Profile.Model
    | OnFieldInput Field String
    | GotBioEditorMsg MarkdownEditor.Msg
    | AddInterest
    | RemoveInterest String
    | ClickedSave
    | GotSaveResult (RemoteData (Graphql.Http.Error (Maybe Profile.Model)) (Maybe Profile.Model))
    | EnteredAvatar (List File)
    | CompletedAvatarUpload (Result Http.Error String)


type Field
    = FullName
    | Email
    | Location
    | Interest


type alias UpdateResult =
    UR.UpdateResult Model Msg (External Msg)


update : Msg -> Model -> LoggedIn.Model -> UpdateResult
update msg model loggedIn =
    let
        { t } =
            loggedIn.shared.translators
    in
    case msg of
        CompletedLoadProfile profile ->
            let
                nullable a =
                    Maybe.withDefault "" a
            in
            UR.init
                { model
                    | fullName = nullable profile.name
                    , email = nullable profile.email
                    , bio = MarkdownEditor.setContents (nullable profile.bio) model.bio
                    , location = nullable profile.localization
                    , interests = profile.interests
                    , avatar =
                        case profile.avatar |> Avatar.toMaybeString of
                            Just url ->
                                RemoteData.Success url

                            Nothing ->
                                RemoteData.NotAsked
                }

        OnFieldInput field data ->
            let
                newModel =
                    case field of
                        FullName ->
                            { model | fullName = data }

                        Email ->
                            { model | email = data }

                        Location ->
                            { model | location = data }

                        Interest ->
                            { model | interest = data }
            in
            UR.init newModel

        GotBioEditorMsg subMsg ->
            let
                ( bio, bioCmd ) =
                    MarkdownEditor.update subMsg model.bio
            in
            { model | bio = bio }
                |> UR.init
                |> UR.addCmd (Cmd.map GotBioEditorMsg bioCmd)

        AddInterest ->
            let
                newModel =
                    -- Prevent empty and duplicate interests
                    if model.interest /= "" && not (List.any (\interest -> interest == model.interest) model.interests) then
                        { model | interests = model.interest :: model.interests, interest = "" }

                    else
                        model
            in
            UR.init newModel

        RemoveInterest interest ->
            UR.init
                { model
                    | interests =
                        model.interests
                            |> List.filter (\x -> x /= interest)
                }

        ClickedSave ->
            case loggedIn.profile of
                RemoteData.Success profile ->
                    let
                        newProfile =
                            modelToProfile model profile
                    in
                    model
                        |> UR.init
                        |> UR.addExt (LoggedIn.UpdatedLoggedIn { loggedIn | profile = RemoteData.Loading })
                        |> UR.addCmd
                            (Api.Graphql.mutation loggedIn.shared
                                (Just loggedIn.authToken)
                                (Profile.mutation (Profile.profileToForm newProfile))
                                GotSaveResult
                            )

                _ ->
                    UR.init model
                        |> UR.logImpossible msg
                            "Tried saving profile, but current profile wasn't loaded"
                            (Just loggedIn.accountName)
                            { moduleName = "Page.Profile.Editor", function = "update" }
                            []

        GotSaveResult (RemoteData.Success (Just profile)) ->
            model
                |> UR.init
                |> UR.addExt (LoggedIn.ProfileLoaded profile |> LoggedIn.ExternalBroadcast)
                |> UR.addExt (LoggedIn.ShowFeedback Feedback.Success (t "profile.edit_success"))
                |> UR.addCmd (Route.pushUrl loggedIn.shared.navKey (Route.Profile loggedIn.accountName))
                |> UR.addBreadcrumb
                    { type_ = Log.DebugBreadcrumb
                    , category = msg
                    , message = "Successfully saved profile"
                    , data = Dict.empty
                    , level = Log.DebugLevel
                    }

        GotSaveResult (RemoteData.Success Nothing) ->
            model
                |> UR.init

        GotSaveResult (RemoteData.Failure e) ->
            model
                |> UR.init
                |> UR.addExt (LoggedIn.UpdatedLoggedIn { loggedIn | profile = RemoteData.Failure e })
                |> UR.logGraphqlError msg
                    (Just loggedIn.accountName)
                    "Got an error when trying to save profile"
                    { moduleName = "Page.Profile.Editor", function = "update" }
                    []
                    e

        GotSaveResult _ ->
            UR.init model

        EnteredAvatar (file :: _) ->
            let
                uploadAvatar file_ =
                    Api.uploadImage loggedIn.shared file_ CompletedAvatarUpload
            in
            case loggedIn.profile of
                RemoteData.Success _ ->
                    model
                        |> UR.init
                        |> UR.addCmd (uploadAvatar file)

                _ ->
                    UR.init model
                        |> UR.logImpossible msg
                            "Tried uploading avatar, but profile wasn't loaded"
                            (Just loggedIn.accountName)
                            { moduleName = "Page.Profile.Editor", function = "update" }
                            []

        EnteredAvatar [] ->
            UR.init model

        CompletedAvatarUpload (Ok a) ->
            UR.init { model | avatar = RemoteData.Success a }

        CompletedAvatarUpload (Err err) ->
            UR.init { model | avatar = RemoteData.Failure err }
                |> UR.logHttpError msg
                    (Just loggedIn.accountName)
                    "Got an error when uploading avatar"
                    { moduleName = "Page.Profile.Editor", function = "update" }
                    []
                    err
                |> UR.addExt (LoggedIn.ShowFeedback Feedback.Failure (t "error.invalid_image_file"))


modelToProfile : Model -> Profile.Model -> Profile.Model
modelToProfile model profile =
    { profile
        | name = Just model.fullName
        , email = Just model.email
        , localization = Just model.location
        , interests = model.interests
        , bio = Just model.bio.contents
        , avatar =
            model.avatar
                |> RemoteData.map Avatar.fromString
                |> RemoteData.withDefault profile.avatar
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
        |> MarkdownEditor.withSubscription model.bio GotBioEditorMsg


receiveBroadcast : LoggedIn.BroadcastMsg -> Maybe Msg
receiveBroadcast broadcastMsg =
    case broadcastMsg of
        LoggedIn.ProfileLoaded profile ->
            Just (CompletedLoadProfile profile)

        _ ->
            Nothing


msgToString : Msg -> List String
msgToString msg =
    case msg of
        CompletedLoadProfile _ ->
            [ "CompletedLoadProfile" ]

        OnFieldInput _ _ ->
            [ "OnFieldInput" ]

        GotBioEditorMsg subMsg ->
            "GotBioEditorMsg" :: MarkdownEditor.msgToString subMsg

        AddInterest ->
            [ "AddInterest" ]

        RemoveInterest _ ->
            [ "RemoveInterest" ]

        ClickedSave ->
            [ "ClickedSave" ]

        GotSaveResult r ->
            [ "GotSaveResult", UR.remoteDataToString r ]

        CompletedAvatarUpload _ ->
            [ "CompletedAvatarUpload" ]

        EnteredAvatar _ ->
            [ "EnteredAvatar" ]
