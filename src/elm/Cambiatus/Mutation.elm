-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Cambiatus.Mutation exposing (..)

import Cambiatus.Enum.CurrencyType
import Cambiatus.Enum.Language
import Cambiatus.Enum.ReactionEnum
import Cambiatus.InputObject
import Cambiatus.Interface
import Cambiatus.Object
import Cambiatus.Scalar
import Cambiatus.ScalarCodecs
import Cambiatus.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


type alias AddCommunityPhotosRequiredArguments =
    { symbol : String
    , urls : List String
    }


{-| [Auth required - Admin only] Adds photos of a community
-}
addCommunityPhotos :
    AddCommunityPhotosRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Community
    -> SelectionSet (Maybe decodesTo) RootMutation
addCommunityPhotos requiredArgs object_ =
    Object.selectionForCompositeField "addCommunityPhotos" [ Argument.required "symbol" requiredArgs.symbol Encode.string, Argument.required "urls" requiredArgs.urls (Encode.string |> Encode.list) ] object_ (identity >> Decode.nullable)


type alias CompleteObjectiveRequiredArguments =
    { id : Int }


{-| [Auth required - Admin only] Complete an objective
-}
completeObjective :
    CompleteObjectiveRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Objective
    -> SelectionSet (Maybe decodesTo) RootMutation
completeObjective requiredArgs object_ =
    Object.selectionForCompositeField "completeObjective" [ Argument.required "id" requiredArgs.id Encode.int ] object_ (identity >> Decode.nullable)


type alias ContributionRequiredArguments =
    { amount : Float
    , communityId : String
    , currency : Cambiatus.Enum.CurrencyType.CurrencyType
    }


{-| [Auth required] Create a new contribution
-}
contribution :
    ContributionRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Contribution
    -> SelectionSet (Maybe decodesTo) RootMutation
contribution requiredArgs object_ =
    Object.selectionForCompositeField "contribution" [ Argument.required "amount" requiredArgs.amount Encode.float, Argument.required "communityId" requiredArgs.communityId Encode.string, Argument.required "currency" requiredArgs.currency (Encode.enum Cambiatus.Enum.CurrencyType.toString) ] object_ (identity >> Decode.nullable)


{-| [Auth required] A mutation to delete user's address data
-}
deleteAddress :
    SelectionSet decodesTo Cambiatus.Object.DeleteStatus
    -> SelectionSet (Maybe decodesTo) RootMutation
deleteAddress object_ =
    Object.selectionForCompositeField "deleteAddress" [] object_ (identity >> Decode.nullable)


{-| [Auth required] A mutation to delete user's kyc data
-}
deleteKyc :
    SelectionSet decodesTo Cambiatus.Object.DeleteStatus
    -> SelectionSet (Maybe decodesTo) RootMutation
deleteKyc object_ =
    Object.selectionForCompositeField "deleteKyc" [] object_ (identity >> Decode.nullable)


type alias DeleteNewsRequiredArguments =
    { newsId : Int }


{-| [Auth required] Deletes News
-}
deleteNews :
    DeleteNewsRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.DeleteStatus
    -> SelectionSet (Maybe decodesTo) RootMutation
deleteNews requiredArgs object_ =
    Object.selectionForCompositeField "deleteNews" [ Argument.required "newsId" requiredArgs.newsId Encode.int ] object_ (identity >> Decode.nullable)


type alias GenAuthRequiredArguments =
    { account : String }


{-| Generates a new signIn request
-}
genAuth :
    GenAuthRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Request
    -> SelectionSet decodesTo RootMutation
genAuth requiredArgs object_ =
    Object.selectionForCompositeField "genAuth" [ Argument.required "account" requiredArgs.account Encode.string ] object_ identity


type alias HasNewsRequiredArguments =
    { communityId : String
    , hasNews : Bool
    }


{-| [Auth required - Admin only] Set has\_news flag of community
-}
hasNews :
    HasNewsRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Community
    -> SelectionSet (Maybe decodesTo) RootMutation
hasNews requiredArgs object_ =
    Object.selectionForCompositeField "hasNews" [ Argument.required "communityId" requiredArgs.communityId Encode.string, Argument.required "hasNews" requiredArgs.hasNews Encode.bool ] object_ (identity >> Decode.nullable)


type alias HighlightedNewsOptionalArguments =
    { newsId : OptionalArgument Int }


type alias HighlightedNewsRequiredArguments =
    { communityId : String }


{-| [Auth required - Admin only] Set highlighted news of community. If news\_id is not present, sets highlighted as nil
-}
highlightedNews :
    (HighlightedNewsOptionalArguments -> HighlightedNewsOptionalArguments)
    -> HighlightedNewsRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Community
    -> SelectionSet (Maybe decodesTo) RootMutation
highlightedNews fillInOptionals requiredArgs object_ =
    let
        filledInOptionals =
            fillInOptionals { newsId = Absent }

        optionalArgs =
            [ Argument.optional "newsId" filledInOptionals.newsId Encode.int ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "highlightedNews" (optionalArgs ++ [ Argument.required "communityId" requiredArgs.communityId Encode.string ]) object_ (identity >> Decode.nullable)


type alias NewsOptionalArguments =
    { communityId : OptionalArgument String
    , id : OptionalArgument Int
    , scheduling : OptionalArgument Cambiatus.ScalarCodecs.DateTime
    }


type alias NewsRequiredArguments =
    { description : String
    , title : String
    }


{-| [Auth required - Admin only] News mutation, that allows for creating news on a community
-}
news :
    (NewsOptionalArguments -> NewsOptionalArguments)
    -> NewsRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.News
    -> SelectionSet (Maybe decodesTo) RootMutation
news fillInOptionals requiredArgs object_ =
    let
        filledInOptionals =
            fillInOptionals { communityId = Absent, id = Absent, scheduling = Absent }

        optionalArgs =
            [ Argument.optional "communityId" filledInOptionals.communityId Encode.string, Argument.optional "id" filledInOptionals.id Encode.int, Argument.optional "scheduling" filledInOptionals.scheduling (Cambiatus.ScalarCodecs.codecs |> Cambiatus.Scalar.unwrapEncoder .codecDateTime) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "news" (optionalArgs ++ [ Argument.required "description" requiredArgs.description Encode.string, Argument.required "title" requiredArgs.title Encode.string ]) object_ (identity >> Decode.nullable)


type alias PreferenceOptionalArguments =
    { claimNotification : OptionalArgument Bool
    , digest : OptionalArgument Bool
    , language : OptionalArgument Cambiatus.Enum.Language.Language
    , transferNotification : OptionalArgument Bool
    }


{-| [Auth required] A mutation to only the preferences of the logged user
-}
preference :
    (PreferenceOptionalArguments -> PreferenceOptionalArguments)
    -> SelectionSet decodesTo Cambiatus.Object.User
    -> SelectionSet (Maybe decodesTo) RootMutation
preference fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { claimNotification = Absent, digest = Absent, language = Absent, transferNotification = Absent }

        optionalArgs =
            [ Argument.optional "claimNotification" filledInOptionals.claimNotification Encode.bool, Argument.optional "digest" filledInOptionals.digest Encode.bool, Argument.optional "language" filledInOptionals.language (Encode.enum Cambiatus.Enum.Language.toString), Argument.optional "transferNotification" filledInOptionals.transferNotification Encode.bool ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "preference" optionalArgs object_ (identity >> Decode.nullable)


type alias ReactToNewsRequiredArguments =
    { newsId : Int
    , reactions : List Cambiatus.Enum.ReactionEnum.ReactionEnum
    }


{-| [Auth required] Add or update reactions from user in a news through news\_receipt
-}
reactToNews :
    ReactToNewsRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.NewsReceipt
    -> SelectionSet (Maybe decodesTo) RootMutation
reactToNews requiredArgs object_ =
    Object.selectionForCompositeField "reactToNews" [ Argument.required "newsId" requiredArgs.newsId Encode.int, Argument.required "reactions" requiredArgs.reactions (Encode.enum Cambiatus.Enum.ReactionEnum.toString |> Encode.list) ] object_ (identity >> Decode.nullable)


type alias ReadRequiredArguments =
    { newsId : Int }


{-| [Auth required] Mark news as read, creating a new news\_receipt without reactions
-}
read :
    ReadRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.NewsReceipt
    -> SelectionSet (Maybe decodesTo) RootMutation
read requiredArgs object_ =
    Object.selectionForCompositeField "read" [ Argument.required "newsId" requiredArgs.newsId Encode.int ] object_ (identity >> Decode.nullable)


type alias ReadNotificationRequiredArguments =
    { input : Cambiatus.InputObject.ReadNotificationInput }


{-| [Auth required] Mark a notification history as read
-}
readNotification :
    ReadNotificationRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.NotificationHistory
    -> SelectionSet decodesTo RootMutation
readNotification requiredArgs object_ =
    Object.selectionForCompositeField "readNotification" [ Argument.required "input" requiredArgs.input Cambiatus.InputObject.encodeReadNotificationInput ] object_ identity


type alias RegisterPushRequiredArguments =
    { input : Cambiatus.InputObject.PushSubscriptionInput }


{-| [Auth required] Register an push subscription on Cambiatus
-}
registerPush :
    RegisterPushRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.PushSubscription
    -> SelectionSet decodesTo RootMutation
registerPush requiredArgs object_ =
    Object.selectionForCompositeField "registerPush" [ Argument.required "input" requiredArgs.input Cambiatus.InputObject.encodePushSubscriptionInput ] object_ identity


type alias SignInOptionalArguments =
    { invitationId : OptionalArgument String }


type alias SignInRequiredArguments =
    { account : String
    , password : String
    }


{-| Sign In on the platform, gives back an access token

  - invitationId - Optional, used to auto invite an user to a community

-}
signIn :
    (SignInOptionalArguments -> SignInOptionalArguments)
    -> SignInRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Session
    -> SelectionSet decodesTo RootMutation
signIn fillInOptionals requiredArgs object_ =
    let
        filledInOptionals =
            fillInOptionals { invitationId = Absent }

        optionalArgs =
            [ Argument.optional "invitationId" filledInOptionals.invitationId Encode.string ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "signIn" (optionalArgs ++ [ Argument.required "account" requiredArgs.account Encode.string, Argument.required "password" requiredArgs.password Encode.string ]) object_ identity


type alias SignUpOptionalArguments =
    { address : OptionalArgument Cambiatus.InputObject.AddressUpdateInput
    , invitationId : OptionalArgument String
    , kyc : OptionalArgument Cambiatus.InputObject.KycDataUpdateInput
    }


type alias SignUpRequiredArguments =
    { account : String
    , email : String
    , name : String
    , publicKey : String
    , userType : String
    }


{-| Creates a new user account

  - account - EOS Account, must have 12 chars long and use only [a-z] and [0-5]
  - address - Optional, Address data
  - email - User's email
  - invitationId - Optional, used to auto invite an user to a community
  - kyc - Optional, KYC data
  - name - User's Full name
  - publicKey - EOS Account public key, used for creating a new account
  - userType - User type informs if its a 'natural' or 'juridical' user for regular users and companies

-}
signUp :
    (SignUpOptionalArguments -> SignUpOptionalArguments)
    -> SignUpRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Session
    -> SelectionSet decodesTo RootMutation
signUp fillInOptionals requiredArgs object_ =
    let
        filledInOptionals =
            fillInOptionals { address = Absent, invitationId = Absent, kyc = Absent }

        optionalArgs =
            [ Argument.optional "address" filledInOptionals.address Cambiatus.InputObject.encodeAddressUpdateInput, Argument.optional "invitationId" filledInOptionals.invitationId Encode.string, Argument.optional "kyc" filledInOptionals.kyc Cambiatus.InputObject.encodeKycDataUpdateInput ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "signUp" (optionalArgs ++ [ Argument.required "account" requiredArgs.account Encode.string, Argument.required "email" requiredArgs.email Encode.string, Argument.required "name" requiredArgs.name Encode.string, Argument.required "publicKey" requiredArgs.publicKey Encode.string, Argument.required "userType" requiredArgs.userType Encode.string ]) object_ identity


type alias UpdateUserRequiredArguments =
    { input : Cambiatus.InputObject.UserUpdateInput }


{-| [Auth required] A mutation to update a user
-}
updateUser :
    UpdateUserRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.User
    -> SelectionSet (Maybe decodesTo) RootMutation
updateUser requiredArgs object_ =
    Object.selectionForCompositeField "updateUser" [ Argument.required "input" requiredArgs.input Cambiatus.InputObject.encodeUserUpdateInput ] object_ (identity >> Decode.nullable)


type alias UpsertAddressRequiredArguments =
    { input : Cambiatus.InputObject.AddressUpdateInput }


{-| [Auth required] Updates user's address if it already exists or inserts a new one if user hasn't it yet.
-}
upsertAddress :
    UpsertAddressRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.Address
    -> SelectionSet (Maybe decodesTo) RootMutation
upsertAddress requiredArgs object_ =
    Object.selectionForCompositeField "upsertAddress" [ Argument.required "input" requiredArgs.input Cambiatus.InputObject.encodeAddressUpdateInput ] object_ (identity >> Decode.nullable)


type alias UpsertKycRequiredArguments =
    { input : Cambiatus.InputObject.KycDataUpdateInput }


{-| [Auth required] Updates user's KYC info if it already exists or inserts a new one if user hasn't it yet.
-}
upsertKyc :
    UpsertKycRequiredArguments
    -> SelectionSet decodesTo Cambiatus.Object.KycData
    -> SelectionSet (Maybe decodesTo) RootMutation
upsertKyc requiredArgs object_ =
    Object.selectionForCompositeField "upsertKyc" [ Argument.required "input" requiredArgs.input Cambiatus.InputObject.encodeKycDataUpdateInput ] object_ (identity >> Decode.nullable)
