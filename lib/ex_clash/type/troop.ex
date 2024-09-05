defmodule ExClash.Type.Troop do
  @moduledoc """
  The Troop struct.

  Note: The hero pets are considered troops, so they will be included the
  troop array for the player details.

  Attributes:

    * `name` - The name of the troop.
    * `level` - The current level of the troop.
    * `max_level` - The maximum level of the troop.
    * `village` - Which `ExClash.village()` this toop belongs to.
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
