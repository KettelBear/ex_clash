defmodule ExClash.War.Player do
  @moduledoc """
  A player that participated in a war.
  """

  alias ExClash.War.Attack

  @typedoc """
  """
  @type t() :: %__MODULE__{
    tag: String.t(),
    name: String.t(),
    map_position: integer(),
    townhall_level: integer(),
    attacks: [Attack.t()],
    best_opponent_attack: Attack.t(),
    opponent_attacks: integer()
  }

  defstruct [
    :tag,
    :name,
    :map_position,
    :townhall_level,
    :attacks,
    :best_opponent_attack,
    :opponent_attacks,
  ]

  @doc false
  @spec format(api_player :: ExClash.cell_map()) :: __MODULE__.t()
  def format(api_player) do
    {attacks, api_player} = Map.pop(api_player, "attacks")
    {best_opp_attack, api_player} = Map.pop(api_player, "bestOpponentAttack")

     %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_player, __MODULE__) |
      attacks: format_attacks(attacks),
      best_opponent_attack: format_opp_attack(best_opp_attack),
     }
  end

  defp format_attacks(nil), do: nil
  defp format_attacks(attacks) do
    Enum.map(attacks, &ExClash.HTTP.resp_to_struct(&1, Attack))
  end

  defp format_opp_attack(nil), do: nil
  defp format_opp_attack(opp_attack) do
    ExClash.HTTP.resp_to_struct(opp_attack, Attack)
  end
end
