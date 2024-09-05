defmodule ExClash.Type.Location do
  @moduledoc """
  The Location struct.

  Attributes:
    * `id` - The location identification number.
    * `name` - The name of the location.
    * `is_country` - Boolean stating if the location is a country.
    * `country_code` - The country code.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    is_country: boolean(),
    country_code: String.t()
  }

  defstruct [:id, :name, :is_country, :country_code]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
