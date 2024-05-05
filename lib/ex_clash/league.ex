defmodule ExClash.League do
  @moduledoc """
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: list(ExClash.Icon.t())
  }

  defstruct [:id, :name, :icon_urls]

  def format(api_league) do
    icons = Map.get(api_league, "iconUrls")

    %__MODULE__{
      id: Map.get(api_league, "id"),
      name: Map.get(api_league, "name"),
      icon_urls: format_icon_urls(icons)
    }
  end

  defp format_icon_urls(nil), do: nil
  defp format_icon_urls(icon_urls) do
    ExClash.resp_to_struct(icon_urls, ExClash.IconUrls)
  end
end
