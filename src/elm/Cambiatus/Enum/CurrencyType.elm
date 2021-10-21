-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Cambiatus.Enum.CurrencyType exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-|

  - Brl - Brazil Reais
  - Btc - Bitcoin
  - Crc - Costa Rica Colones
  - Eos - EOS
  - Eth - Ethereum
  - Usd - US dollars

-}
type CurrencyType
    = Brl
    | Btc
    | Crc
    | Eos
    | Eth
    | Usd


list : List CurrencyType
list =
    [ Brl, Btc, Crc, Eos, Eth, Usd ]


decoder : Decoder CurrencyType
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "BRL" ->
                        Decode.succeed Brl

                    "BTC" ->
                        Decode.succeed Btc

                    "CRC" ->
                        Decode.succeed Crc

                    "EOS" ->
                        Decode.succeed Eos

                    "ETH" ->
                        Decode.succeed Eth

                    "USD" ->
                        Decode.succeed Usd

                    _ ->
                        Decode.fail ("Invalid CurrencyType type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : CurrencyType -> String
toString enum =
    case enum of
        Brl ->
            "BRL"

        Btc ->
            "BTC"

        Crc ->
            "CRC"

        Eos ->
            "EOS"

        Eth ->
            "ETH"

        Usd ->
            "USD"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe CurrencyType
fromString enumString =
    case enumString of
        "BRL" ->
            Just Brl

        "BTC" ->
            Just Btc

        "CRC" ->
            Just Crc

        "EOS" ->
            Just Eos

        "ETH" ->
            Just Eth

        "USD" ->
            Just Usd

        _ ->
            Nothing
