defmodule ExClash.Type.District do
  @moduledoc """
  The Clan Capital District struct.

  Attributes:

    * `id` - The integer ID of the district.
    * `name` - The name of the district.
    * `district_hall_level` - The level of the district.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    district_hall_level: integer()
  }

  defstruct [:id, :name, :district_hall_level]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
