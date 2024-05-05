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

    @type t() :: %{
      one: list(String.t()),
      two: list(String.t()),
      three: list(String.t()),
      four: list(String.t()),
      five: list(String.t()),
      six: list(String.t()),
      seven: list(String.t()),
    }

    defstruct [:one, :two, :three, :four, :five, :six, :seven]
  end

  @type t() :: %__MODULE__{
    clans: ExClash.War.Clan.t(),
    rounds: Rounds.t(),
    season: String.t(),
    state: war_state()
  }

  defstruct [:clans, :rounds, :season, :state]

  def format(war_league) do
    clans = Map.get(war_league, "clans")

    %__MODULE__{
      clans: Enum.map(clans, &ExClash.War.Clan.format/1),
      rounds: Map.get(war_league, "rounds") |> format_rounds(),
      season: Map.get(war_league, "season"),
      state: Map.get(war_league, "state") |> ExClash.camel_to_atom()
    }
  end

  defp format_rounds(rounds) do
    rounds
  end
end
