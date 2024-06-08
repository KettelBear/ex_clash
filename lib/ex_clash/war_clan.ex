defmodule ExClash.WarClan do
  @moduledoc """
  """

  @type t() :: %__MODULE__{
    attacks: integer(),
    badge_urls: map(),
    clan_level: integer(),
    destruction_percentage: float(),
    members: [ExClash.WarPlayer.t()],
    name: String.t(),
    stars: integer(),
    tag: String.t()
  }

  defstruct [
    :attacks,
    :badge_urls,
    :clan_level,
    :destruction_percentage,
    :members,
    :name,
    :stars,
    :tag
  ]

  @doc false
  @spec format(api_clan :: ExClash.cell_map()) :: __MODULE__.t()
  def format(api_clan) do
    {api_players, api_clan} = Map.pop(api_clan, "members")
    {badges, api_clan} = Map.pop(api_clan, "badgeUrls")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.HTTP.resp_to_struct(badges, ExClash.Badges),
      members: format_players(api_players),
    }
  end

  defp format_players(nil), do: nil
  defp format_players(players), do: Enum.map(players, &ExClash.WarPlayer.format/1)
end
