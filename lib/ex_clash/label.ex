defmodule ExClash.Label do
  @moduledoc """
  The Label struct.

  Attributes:

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

  def format(api_label) do
    icons = Map.get(api_label, "iconUrls")

    %__MODULE__{
      id: Map.get(api_label, "id"),
      name: Map.get(api_label, "name"),
      icon_urls: ExClash.HTTP.resp_to_struct(icons, ExClash.IconUrls)
    }
  end
end
