defmodule ExClash.Clan.Capital do
  @moduledoc """
  /capitalleagues
  /capitalleagues/{leagueId}
  /clans/{clanTag}/capitalraidseasons
  """
  alias ExClash.Paging
  alias ExClash.League
  alias ExClash.Clan.Capital.District

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

    * `limit` - Limit the number of items returned in the response.

    * `after` - Return only items that occur after this marker.

    * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Clan.Capital.leagues(id: 85000021)
      %ExClash.League{id: 85000021, name: "Titan League I", icon_urls: nil}

      iex> ExClash.Clan.Capital.leagues(limit: 3, after: "eyJwb3MiOjN9")
      {
        [
          %ExClash.League{id: 85000003, name: "Bronze League I"},
          %ExClash.League{id: 85000004, name: "Silver League III"},
          %ExClash.League{id: 85000005, name: "Silver League II"}
        ],
        %ExClash.Paging{after: "eyJwb3MiOjZ9", before: "eyJwb3MiOjN9"}
      }
  """
  @spec leagues(params :: Keyword.t())
      :: League.t() | {list(League.t()), Paging.t()} | {:error, atom()}
  def leagues(params \\ [])

  def leagues([{:id, id} | params]) do
    case ExClash.HTTP.get("/capitalleagues/#{id}", params) do
      {:ok, league} -> League.format(league)
      err -> err
    end
  end

  def leagues(params) do
    case ExClash.HTTP.get("/capitalleagues", params) do
      {:ok, %{"items" => items, "paging" => paging}} ->
        {Enum.map(items, &League.format/1), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Format Supercell's for the Clan Capital.
  """
  @spec format(api_capital :: ExClash.cell_map()) :: __MODULE__.t()
  def format(nil), do: nil
  def format(api_capital) do
    districts = Map.get(api_capital, "districts", [])

    %__MODULE__{
      capital_hall_level: Map.get(api_capital, "capitalHallLevel"),
      districts: Enum.map(districts, &ExClash.HTTP.resp_to_struct(&1, District))
    }
  end
end
