defmodule ExClash.Type.Spell do
  @moduledoc """
  The Spell struct.

  Attributes:

    * `name` -  The name of the spell.
    * `level` - The current level of the spell.
    * `max_level` - The maximum level for the spell for the given town hall.
    * `village` - Which village the spell belongs to.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
