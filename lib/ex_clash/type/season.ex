  defmodule ExClash.Type.Season do
    @moduledoc """
    The Season struct.

    These seasons that the player achieves.

    Attributes:

      * `id` - The string value as an ID, usually MMMM-DD.
      * `rank` - The rank number the player achieved.
      * `trophies` - The number of trophies the player earned.
    """

    @behaviour ExClash.Type

    @type t() :: %__MODULE__{
      id: String.t(),
      rank: integer(),
      trophies: integer()
    }

    defstruct [:id, :rank, :trophies]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
