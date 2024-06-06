defmodule ExClash.Label do
  @moduledoc """
  The Label struct.

  ## Attributes

    * `id` - The identifier of the Label.
    * `name` - The name of the Label.
    * `icon_urls` - See `ExClash.IconUrls` for details.
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: ExClash.IconUrls.t()
  }

  defstruct [:id, :name, :icon_urls]

  @spec format(data :: ExClash.cell_map() | list(ExClash.cell_map())) :: __MODULE__.t() | list(__MODULE__.t())
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    %__MODULE__{
      id: Map.get(data, "id"),
      name: Map.get(data, "name"),
      icon_urls: ExClash.HTTP.resp_to_struct(Map.get(data, "iconUrls"), ExClash.IconUrls)
    }
  end
end
