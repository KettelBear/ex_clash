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
    clans: list(ExClash.WarLeagueClan.t()),
    rounds: Rounds.t(),
    season: String.t(),
    state: war_state()
  }

  defstruct [:clans, :rounds, :season, :state]

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
    Enum.map(clans, &ExClash.WarLeagueClan.format/1)
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
