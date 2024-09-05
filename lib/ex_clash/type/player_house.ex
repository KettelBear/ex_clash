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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(%{"elements" => elements} = _data) do
    elements
    |> Enum.reduce(%{}, fn %{"id" => id, "type" => type}, acc ->
      Map.put(acc, String.to_atom(type), id)
    end)
    |> then(&struct(__MODULE__, &1))
  end
end
