defmodule ExClash.Type.IconUrls do
  @moduledoc """
  The IconUrls struct.

  These are the URLs for the various icons that belong to leagues and labels.

  Attributes:

    * `tiny` - The URL leading to the tiny icon.
    * `small` - The URL leading to the small icon.
    * `medium` - The URL leading to the medium icon.
    * `large` - The URL leading to the large icon.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    tiny: String.t(),
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:tiny, :small, :medium, :large]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
