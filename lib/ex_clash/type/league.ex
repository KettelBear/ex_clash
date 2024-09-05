defmodule ExClash.Type.League do
  @moduledoc """
  The League struct.

  This simply represents a league in Clash of Clans.

  Attributes:

    * `id` - The league id number.
    * `name` - The name of the league.
    * `icon_urls` - See `ExClash.IconUrls` for more details.
  """

  @behaviour ExClash.Type

  @typedoc """
  `YYYY-MM` as a String, representing the season.

  Although just a string, Supercell's "season" takes a very specific format
  of `YYYY-MM`. That should be the expected format of `cell_season`.

  ## Examples

      "2024-01"
  """
  @type cell_season() :: String.t()

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: list(ExClash.IconUrls.t())
  }

  defstruct [:id, :name, :icon_urls]

  @doc """
  Format the Supercell league into an `ExClash.League`.

  There are many entities that can be part of leagues. These include;
  Clans, Players, Capitals. This will take the JSON object and return this
  struct.
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    icons = Map.get(data, "iconUrls")

    %__MODULE__{
      id: Map.get(data, "id"),
      name: Map.get(data, "name"),
      icon_urls: ExClash.Type.IconUrls.format(icons)
    }
  end
end
