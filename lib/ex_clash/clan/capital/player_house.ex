defmodule ExClash.Clan.Capital.PlayerHouse do
  @moduledoc """
  """

  @type t() :: %__MODULE__{
    ground: integer(),
    walls: integer(),
    roof: integer(),
    decoration: integer()
  }

  defstruct [:ground, :walls, :roof, :decoration]

  @spec format(api_house :: map()) :: __MODULE__.t()
  def format(%{"elements" => elements}) do
    elements
    |> Enum.reduce(%{}, fn %{"id" => id, "type" => type}, acc ->
      Map.put(acc, String.to_atom(type), id)
    end)
    |> then(&struct(__MODULE__, &1))
  end

  def format(_), do: nil
end
