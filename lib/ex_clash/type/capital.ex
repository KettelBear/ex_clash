defmodule ExClash.Type.Capital do
  @moduledoc """
  The Capital struct.

  Attributes:

    * `capital_hall_level` - The integer level of the capital hall for the clan.
    * `districts` - See `ExClash.District` for more information.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(District.t())
  }

  defstruct [:capital_hall_level, :districts]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
