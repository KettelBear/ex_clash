defmodule ExClash.League do
  @moduledoc """
  The League struct.

  This simply represents a league in Clash of Clans.

  Attributes:

    * `id` - The league id number.

    * `name` - The name of the league.

    * `icon_urls` - See `ExClash.IconUrls` for more details.
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: list(ExClash.IconUrls.t())
  }

  defstruct [:id, :name, :icon_urls]

  @doc """
  There are many entities that can be part of leagues. These include;
  Clans, Players, Capitals. This will take the JSON object and return this
  struct.
  """
  @spec format(api_league :: ExClash.cell_map()) :: __MODULE__.t()
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
    ExClash.HTTP.resp_to_struct(icon_urls, ExClash.IconUrls)
  end
end
