defmodule ExClash.WarLeague do
  @moduledoc """
  The Clan War League struct.

  Attributes:

    * `clans` - The clans that are part of the war league group.

    * `rounds` - See `ExClash.WarLeague.Rounds` for more details.

    * `season` - The MMMM-DD identified season.

    * `state` - The `war_state` of the Clan War League.
  """

  @type war_state() ::
    :group_not_found
    | :not_in_war
    | :preparation
    | :in_war
    | :ended

  defmodule Rounds do
    @moduledoc """
    The War League Round struct.

    Attributes:

      * `one` - The list of war tags for the first day.

      * `two` - The list of war tags for the second day.

      * `three` - The list of war tags for the third day.

      * `four` - The list of war tags for the fourth day.

      * `five` - The list of war tags for the fifth day.

      * `six` - The list of war tags for the sixth day.

      * `seven` - The list of war tags for the seventh day.
    """

    @typedoc """
    A list of War Tags.
    """
    @type round() :: list(ExClash.tag())

    @type t() :: %__MODULE__{
      one: list(ExClash.tag()),
      two: list(ExClash.tag()),
      three: list(ExClash.tag()),
      four: list(ExClash.tag()),
      five: list(ExClash.tag()),
      six: list(ExClash.tag()),
      seven: list(ExClash.tag())
    }

    defstruct [:one, :two, :three, :four, :five, :six, :seven]
  end

  @type t() :: %__MODULE__{
    clans: list(ExClash.WarLeagueClan.t()),
    rounds: Rounds.t(),
    season: String.t(),
    state: war_state()
  }

  defstruct [:clans, :rounds, :season, :state]

  # TODO:
  @doc """
  
  """
  @spec war(war_tag :: ExClash.tag()) :: ExClash.War.t() | {:error, atom()}
  def war(war_tag) do
    case ExClash.HTTP.get("/clanwarleagues/wars/#{war_tag}") do
      {:ok, war} ->
        war
        # This is a duplicate value.
        |> Map.delete("warStartTime")
        |> ExClash.War.format()

      err ->
        err
    end
  end

  @doc """
  Get the details of the war league for the provided `id`.

  ## Parameters

    * `id` - The integer ID of the war league.

  ## Examples

      iex(34)> ExClash.WarLeague.one(48000018)
      %ExClash.League{id: 48000018, name: "Champion League I", icon_urls: nil}
  """
  @spec one(id :: integer(), opts :: Keyword.t()) :: ExClash.League.t() | {:error, atom()}
  def one(id, opts \\ []) do
    case ExClash.HTTP.get("/warleagues/#{id}", opts) do
      {:ok, league} -> ExClash.League.format(league)
      err -> err
    end
  end

  @doc """
  Get the details of the war leagues.

  ## Parameters

    * `opts` - The available pagination options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex(34)> ExClash.WarLeague.one(48000018)
      %ExClash.League{id: 48000018, name: "Champion League I", icon_urls: nil}
  """
  @spec list(opts :: Keyword.t()) :: list(ExClash.League.t()) | {:error, atom()}
  def list(opts \\ []) do
    case ExClash.HTTP.get("/warleagues", opts) do
      {:ok, %{"items" => leagues, "paging" => paging}} ->
        {ExClash.League.format(leagues), ExClash.Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Format the war league from the API response to the struct.
  """
  @spec format(war_league :: ExClash.cell_map()) :: __MODULE__.t()
  def format(war_league) do
    %__MODULE__{
      clans: Map.get(war_league, "clans") |> ExClash.WarLeagueClan.format(),
      rounds: Map.get(war_league, "rounds") |> format_rounds(),
      season: Map.get(war_league, "season"),
      state: Map.get(war_league, "state") |> ExClash.camel_to_atom()
    }
  end

  defp format_rounds(rounds) do
    format_rounds(%{}, rounds, [:one, :two, :three, :four, :five, :six, :seven])
  end
  defp format_rounds(map, [], []), do: struct(Rounds, map)
  defp format_rounds(map, [%{"warTags" => tags} | rounds], [rnd_num | nums]) do
    map
    |> Map.put(rnd_num, tags)
    |> format_rounds(rounds, nums)
  end
end
