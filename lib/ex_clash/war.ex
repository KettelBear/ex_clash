defmodule ExClash.War do
  @moduledoc """
  """

  alias ExClash.War.Clan, as: WarClan

  @type t() :: %__MODULE__{
    clan: WarClan.t(),
    opponent: WarClan.t(),
    result: String.t(),
    team_size: integer(),
    attacks_per_member: integer(),
    state: war_state(),
    preparation_start_time: DateTime.t(),
    start_time: DateTime.t(),
    end_time: DateTime.t(),
  }

  @typedoc """
  Possible states of a clan in war.
  """
  @type war_state() ::
    :clan_not_found
    | :access_denied
    | :not_in_war
    | :in_matchmaking
    | :enter_war
    | :matched
    | :preparation
    | :war
    | :in_war
    | :war_ended

  @typedoc """
  """
  @type war_log() :: {list(__MODULE__.t()), ExClash.Paging.t()}

  defstruct [
    :clan,
    :opponent,
    :result,
    :team_size,
    :attacks_per_member,
    :state,
    :preparation_start_time,
    :start_time,
    :end_time,
  ]

  @doc false
  @spec format(api_war :: ExClash.cell_map()) :: __MODULE__.t()
  def format(api_war) do
    {api_clan, api_war} = Map.pop(api_war, "clan")
    {api_opponent, api_war} = Map.pop(api_war, "opponent")
    {state, api_war} = Map.pop(api_war, "state")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_war, __MODULE__) |
      clan: WarClan.format(api_clan),
      opponent: WarClan.format(api_opponent),
      state: convert_state(state)
    }
  end

  defp convert_state(nil), do: nil
  defp convert_state(state), do: ExClash.camel_to_atom(state)
end
