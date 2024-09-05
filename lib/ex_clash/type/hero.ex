defmodule ExClash.Type.Hero do
  @moduledoc """
  The Hero struct.

  Attributes:

    * `name` - The hero name.
    * `level` - The hero's current level.
    * `max_level` - The hero's max level possible for the town hall level.
    * `village` - The village that the hero belongs to.
    * `equipment` - See `ExClash.Equipment` for more details.
  """

  @behaviour ExClash.Type

  alias ExClash.Type.Equipment

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village(),
    equipment: list(Equipment.t())
  }

  defstruct [:name, :level, :max_level, :village, :equipment]

  @doc """
  When player details are fetched, this will handle the embedded JSON object
  that are the heroes that the player has.
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {equipment, data} = Map.pop(data, "equipment")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      equipment: Equipment.format(equipment)
    }
  end
end
