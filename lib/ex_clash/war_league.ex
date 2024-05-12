defmodule ExClash.WarLeague do
  @moduledoc """
  The Clan War League struct.
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
    """

    @typedoc """
    A list of War Tags.
    """
    @type round() :: list(ExClash.tag())

    @type t() :: %{
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
    clans: list(ExClash.WarLeague.Clan.t()),
    rounds: Rounds.t(),
    season: String.t(),
    state: war_state()
  }

  defstruct [:clans, :rounds, :season, :state]

  @spec war(war_tag :: ExClash.tag()) :: ExClash.Clan.War.t() | {:error, atom()}
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
  Format the war league from the API response to the struct.
  """
  @spec format(war_league :: ExClash.cell_map()) :: __MODULE__.t()
  def format(war_league) do
    %__MODULE__{
      clans: Map.get(war_league, "clans") |> format_clans(),
      rounds: Map.get(war_league, "rounds") |> format_rounds(),
      season: Map.get(war_league, "season"),
      state: Map.get(war_league, "state") |> ExClash.camel_to_atom()
    }
  end

  defp format_clans(clans) do
    Enum.map(clans, &ExClash.WarLeague.Clan.format/1)
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