defmodule ExClash.Capital do
  @moduledoc """
  The Capital struct.

  ## Attributes

    * `capital_hall_level` - The integer level of the capital hall for the clan.
    * `districts` - See `ExClash.District` for more information.
  """

  alias ExClash.District
  alias ExClash.HTTP
  alias ExClash.League
  alias ExClash.Paging

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(District.t())
  }

  defstruct [:capital_hall_level, :districts]

  @doc """
  Get the names and IDs of the capital leagues.

  If an ID is provided then it will fetch the details of that league which
  will be ID itself and the name of the league.

  ## Param Options

    * `id` - The integer ID of the league. If provided, it will attempt to hit
      the endpoint for that specific Capital League.
    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Capital.leagues(id: 85000021)
      %ExClash.League{id: 85000021, name: "Titan League I", icon_urls: nil}

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
  def leagues(opts \\ [])

  def leagues([{:id, id} | opts]) do
    case HTTP.get("/capitalleagues/#{id}", opts) do
      {:ok, league} -> League.format(league)
      err -> err
    end
  end

  def leagues(opts) do
    case HTTP.get("/capitalleagues", opts) do
      {:ok, %{"items" => items, "paging" => paging}} ->
        {Enum.map(items, &League.format/1), Paging.format(paging)}

      err ->
        err
    end
  end

  # TODO: /clans/{clanTag}/capitalraidseasons

  @doc """
  
  ## Param Options

    * `clan_tag` - Tag for the clan to get past raid seasons.
    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.
  """
  @spec raid_seasons(clan_tag :: String.t(), opts :: Keyword.t()) :: any()
  def raid_seasons(clan_tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{clan_tag}/capitalraidseasons", opts) do
      {:ok, seasons} -> seasons
      err -> err
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
      districts: Enum.map(districts, &HTTP.resp_to_struct(&1, District))
    }
  end
end
