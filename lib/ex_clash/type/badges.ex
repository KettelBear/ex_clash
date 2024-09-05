defmodule ExClash.Type.Badges do
  @moduledoc """
  The Badges struct.

  These are the badges that are associated with `ExClash.Type.Clan`s.

  Attrbiutes:

    * `small` - The smallest size in terms of pixels.
    * `medium` - The medium size.
    * `large` - The largest size.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:small, :medium, :large]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
