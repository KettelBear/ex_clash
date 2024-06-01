defmodule ExClash.Clan.Capital.PlayerHouse do
  @moduledoc """
  The Clan Capital Player House struct.

  Attributes:

    * `ground` - The ID of the ground choice.

    * `walls` - The ID of the walls choice.

    * `roof` - The ID of the roof choice.

    * `decoration` - The ID of the decoration choice.
  """

  @type t() :: %__MODULE__{
    ground: integer(),
    walls: integer(),
    roof: integer(),
    decoration: integer()
  }

  defstruct [:ground, :walls, :roof, :decoration]

  @spec format(api_house :: ExClash.cell_map()) :: __MODULE__.t()
  def format(%{"elements" => elements}) do
    elements
    |> Enum.reduce(%{}, fn %{"id" => id, "type" => type}, acc ->
      Map.put(acc, String.to_atom(type), id)
    end)
    |> then(&struct(__MODULE__, &1))
  end

  def format(_), do: nil
end
