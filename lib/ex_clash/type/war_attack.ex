defmodule ExClash.Type.WarAttack do
  @moduledoc """
  A player's attack in war.
  """

  @behaviour ExClash.Type

  @typedoc """
  """
  @type t() :: %__MODULE__{
    attacker_tag: String.t(),
    defender_tag: String.t(),
    destruction_percentage: integer(),
    duration: integer(),
    order: integer(),
    stars: integer()
  }

  defstruct [
    :attacker_tag,
    :defender_tag,
    :destruction_percentage,
    :duration,
    :order,
    :stars
  ]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
