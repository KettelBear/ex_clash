defmodule ExClash.Troop do
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

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]

  def format(troop) do
    troop
    |> ExClash.HTTP.resp_to_struct(__MODULE__)
    |> fix_village()
  end

  defp fix_village(%{village: village} = achievements) do
    if village == "home" do
      %__MODULE__{achievements | village: :home}
    else
      %__MODULE__{achievements | village: :builder}
    end
  end
end
