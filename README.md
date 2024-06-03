# ExClash

ExClash is an Elixir library for working with Supercell's Clash of Clans API.

[Docs](https://hexdocs.pm/ex_clash)

## Disclaimer

This material is unofficial and is not endorsed by Supercell. For more
information see Supercell's Fan Content
[Policy](https://www.supercell.com/fan-content-policy).

## Installation

The package can be installed by adding `ex_clash` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:ex_clash, "~> 1.0"}
  ]
end
```

## Dependencies

* HTTP requests are made using [Req](https://hexdocs.pm/req/readme.html).
* Due to the aforementioned dependency, this library requires the use of at
  least Elixir `v1.12` or newer. At time of building, Elixir `v1.16` was used.

## Features

* Add your token to any `[ENV].secret.exs` and start using this library.
* Get well-defined structs back from responses instead of parsing maps with
  string keys.
* HTTP functions are available to make your own API requests. Just use
  `ExClash.HTTP.get/2` which will handle auth, the url, and query params for
  you.

## Usage

TODO: Provide copious examples of usage of this library.

## Supercell's Clash of Clans API

Endpoints with ✅ have been implemented. All requests are GET requests except
for the one that is labelled "POST."

### Clan specific information

* ✅ `/clans/{clanTag}/currentwar/leaguegroup`
* ✅ `/clanwarleagues/wars/{warTag}`
* ✅ `/clans/{clanTag}/warlog`
* ✅ `/clans`
* ✅ `/clans/{clanTag}/currentwar`
* ✅ `/clans/{clanTag}`
* ✅ `/clans/{clanTag}/members`
* ✅ `/clans/{clanTag}/capitalraidseasons`

### Player specific information

* ✅ `/players/{playerTag}`
* `/players/{playerTag}/verifytoken` (POST)

### League information

* ✅ `/capitalleagues`
* `/leagues`
* `/leagues/{leagueId}/seasons/{seasonId}`
* `/capitalleagues/{leagueId}`
* `/builderbaseleagues/{leagueId}`
* `/builderbaseleagues`
* `/leagues/{leagueId}`
* `/leagues/{leagueId}/seasons`
* `/warleagues/{leagueId}`
* `/warleagues`

### Rankings

* `/locations/{locationId}/rankings/clans`
* `/locations/{locationId}/rankings/players`
* `/locations/{locationId}/rankings/players-builder-base`
* `/locations/{locationId}/rankings/clans-builder-base`
* `/locations`
* `/locations/{locationId}/rankings/capitals`
* `/locations/{locationId}`

### Gold Pass

* `/goldpass/seasons/current`

### Esports related APIs

Currently, Supercell does not have any Esports related API endpoints.
I'm including this category here because they have the category in their
developer portal.

### Labels
* `/labels/players`
* `/labels/clans`
