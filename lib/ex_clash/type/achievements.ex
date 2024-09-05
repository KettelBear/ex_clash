defmodule ExClash.Type.Achievements do
  @moduledoc """
  The Achievement struct.

  Attributes:

    * `info` - The description of the achievement.
    * `name` - The name of the achievement.
    * `stars` - How many stars the player has earned toward the achievement.
    * `target` - The value that represents the goal.
    * `value` - The current value towards or beyond the `target`.
    * `village` - Whether this belongs to the home village or the builder base.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    info: String.t(),
    name: String.t(),
    stars: integer(),
    target: integer(),
    value: integer(),
    village: ExClash.village()
  }

  defstruct [:info, :name, :stars, :target, :value, :village]

  @doc """
  Format achievements into this struct.

  Players earn achievements, and this will take the JSON response from
  Supercell and convert it into the `ExClash.Type.Achievements` struct.
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    data
    |> Map.delete("completionInfo")
    |> ExClash.cell_map_to_struct(__MODULE__)
  end
end

