defmodule ExClash.Capital do
  @moduledoc """
  The Capital struct.

  Attributes:

    * `capital_hall_level` - The integer level of the capital hall for the clan.
    * `districts` - See `ExClash.District` for more information.
  """

  alias ExClash.District
  alias ExClash.HTTP
  alias ExClash.League
  alias ExClash.Paging
  alias ExClash.RaidSeason

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(District.t())
  }

  defstruct [:capital_hall_level, :districts]

  @doc """
  Get specific details for the league by ID.

  ## Param Options

    * `id` - The integer ID of the league. If provided, it will attempt to hit
      the endpoint for that specific Capital League.

  ## Examples

      iex> ExClash.Capital.leagues(id: 85000021)
      %ExClash.League{id: 85000021, name: "Titan League I", icon_urls: nil}
  """
  @spec league(id :: integer(), opts :: Keyword.t()) :: League.t() | {:error, atom()}
  def league(id, opts \\ []) do
    case HTTP.get("/capitalleagues/#{id}", opts) do
      {:ok, league} -> League.format(league)
      err -> err
    end
  end

  @doc """
  Get the names and IDs of the capital leagues.

  ## Param Options

    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Capital.leagues(limit: 3, after: "eyJwb3MiOjN9")
      {
        [
          %ExClash.League{id: 85000003, name: "Bronze League I"},
          %ExClash.League{id: 85000004, name: "Silver League III"},
          %ExClash.League{id: 85000005, name: "Silver League II"}
        ],
        %ExClash.Paging{after: "eyJwb3MiOjZ9", before: "eyJwb3MiOjN9"}
      }
  """
  @spec leagues(opts :: Keyword.t()) :: League.t() | {list(League.t()), Paging.t()} | {:error, atom()}
  def leagues(opts) do
    case HTTP.get("/capitalleagues", opts) do
      {:ok, %{"items" => items, "paging" => paging}} ->
        {Enum.map(items, &League.format/1), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get the capital raid history for the `clan_tag`.

  The available options are pagination options. A lot of detail comes back from
  this call. For each raid season; the list capitals raided which includes each
  district raided and the list of attacks on each district, the list of defenses
  from each clan that attacked their clan capital including the districts and
  lists of attacks against them, and the list of clan members that participated
  in the raid.

  ## Param Options

    * `clan_tag` - Tag for the clan to get past raid seasons.
    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.
  """
  @spec raid_seasons(clan_tag :: String.t(), opts :: Keyword.t()) :: RaidSeason.response() | {:error, atom()}
  def raid_seasons(clan_tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{clan_tag}/capitalraidseasons", opts) do
      {:ok, %{"items" => seasons, "paging" => paging}} ->
        {RaidSeason.format(seasons), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Format Supercell's response for the Clan Capital.
  """
  @spec format(api_capital :: ExClash.cell_map()) :: __MODULE__.t()
  def format(nil), do: nil
  def format(api_capital) do
    districts = Map.get(api_capital, "districts", [])

    %__MODULE__{
      capital_hall_level: Map.get(api_capital, "capitalHallLevel"),
      districts: HTTP.resp_to_struct(districts, District)
    }
  end
end
