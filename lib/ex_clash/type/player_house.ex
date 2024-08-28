defmodule ExClash.Type.PlayerHouse do
  @moduledoc """
  The Clan Capital Player House struct.

  Attributes:

    * `ground` - The ID of the ground choice.
    * `walls` - The ID of the walls choice.
    * `roof` - The ID of the roof choice.
    * `decoration` - The ID of the decoration choice.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    ground: integer(),
    walls: integer(),
    roof: integer(),
    decoration: integer()
  }

  defstruct [:ground, :walls, :roof, :decoration]

  @spec format(api_house :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(%{"elements" => elements}) do
    elements
    |> Enum.reduce(%{}, fn %{"id" => id, "type" => type}, acc ->
      Map.put(acc, String.to_atom(type), id)
    end)
    |> then(&struct(__MODULE__, &1))
  end
end
