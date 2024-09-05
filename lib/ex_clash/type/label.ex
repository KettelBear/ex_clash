defmodule ExClash.Type.Label do
  @moduledoc """
  The Label struct.

  ## Attributes

    * `id` - The identifier of the Label.
    * `name` - The name of the Label.
    * `icon_urls` - See `ExClash.IconUrls` for details.
  """

  @behaviour ExClash.Type

  alias ExClash.Type.IconUrls

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: ExClash.IconUrls.t()
  }

  defstruct [:id, :name, :icon_urls]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    %__MODULE__{
      id: Map.get(data, "id"),
      name: Map.get(data, "name"),
      icon_urls: data |> Map.get("iconUrls") |> IconUrls.format()
    }
  end
end
