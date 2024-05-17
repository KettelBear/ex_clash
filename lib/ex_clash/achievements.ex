defmodule ExClash.Achievements do
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

  @type t() :: %__MODULE__{
    info: String.t(),
    name: String.t(),
    stars: integer(),
    target: integer(),
    value: integer(),
    village: ExClash.village()
  }

  defstruct [:info, :name, :stars, :target, :value, :village]

  @spec format(ExClash.cell_map()) :: __MODULE__.t()
  def format(achievements) do
    achievements
    |> Map.delete("completionInfo")
    |> ExClash.HTTP.resp_to_struct(__MODULE__)
  end
end

