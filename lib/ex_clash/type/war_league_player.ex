defmodule ExClash.Type.WarLeaguePlayer do
  @moduledoc """
  The War League Player struct.

  Attributes:

    * `name` - The name of the player participant.
    * `tag` - The player's tag.
    * `town_hall_level` - It is in the name.
  """

  @behaviour ExClash.Type

  @type output() :: __MODULE__.t() | list(__MODULE__.t()) | nil

  @type t() :: %__MODULE__{
    name: String.t(),
    tag: String.t(),
    town_hall_level: integer()
  }

  defstruct [:tag, :name, :town_hall_level]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
