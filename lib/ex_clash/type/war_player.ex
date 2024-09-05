defmodule ExClash.Type.WarPlayer do
  @moduledoc """
  A player that participated in a war.
  """

  alias ExClash.WarAttack

  @typedoc """
  """
  @type t() :: %__MODULE__{
    tag: String.t(),
    name: String.t(),
    map_position: integer(),
    townhall_level: integer(),
    attacks: [WarAttack.t()],
    best_opponent_attack: WarAttack.t(),
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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {attacks, data} = Map.pop(data, "attacks")
    {best_opp_attack, data} = Map.pop(data, "bestOpponentAttack")

     %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      attacks: ExClash.Type.WarAttack.format(attacks),
      best_opponent_attack: ExClash.Type.WarAttack.format(best_opp_attack),
     }
  end
end
