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
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    %__MODULE__{
      clans: Map.get(data, "clans") |> ExClash.Type.WarLeagueClan.format(),
      rounds: Map.get(data, "rounds") |> ExClash.Type.WarLeagueRounds.format(),
      season: Map.get(data, "season"),
      state: Map.get(data, "state") |> ExClash.camel_to_atom()
    }
  end
end
