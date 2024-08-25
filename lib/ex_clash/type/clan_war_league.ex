defmodule ExClash.Type.ClanWarLeague do
  @moduledoc """
  The Clan War League struct.

  Attributes:

    * `clans` - The clans that are part of the war league group.
    * `rounds` - See `ExClash.WarLeague.Rounds` for more details.
    * `season` - The MMMM-DD identified season.
    * `state` - The `war_state` of the Clan War League.
  """

  @behaviour ExClash.Type

  @type war_state() :: :group_not_found | :not_in_war | :preparation | :in_war | :ended

  @type t() :: %__MODULE__{
    clans: list(ExClash.WarLeagueClan.t()),
    rounds: ExClash.Type.WarLeagueRound.t(),
    season: String.t(),
    state: war_state()
  }

  defstruct [:clans, :rounds, :season, :state]

  @doc """
  Format the war league from the API response to the struct.
  """
  @spec format(war_league :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(war_league) do
    %__MODULE__{
      clans: Map.get(war_league, "clans") |> ExClash.WarLeagueClan.format(),
      rounds: Map.get(war_league, "rounds") |> format_rounds(),
      season: Map.get(war_league, "season"),
      state: Map.get(war_league, "state") |> ExClash.camel_to_atom()
    }
  end
end
