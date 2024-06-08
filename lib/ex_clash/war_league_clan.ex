defmodule ExClash.WarLeagueClan do
  @moduledoc """
  The Clan struct specific to Clan War Leagues.
  """

  @type t() :: %__MODULE__{
    badge_urls: ExClash.Badges.t(),
    clan_level: integer(),
    members: list(ExClash.WarLeaguePlayer.t()),
    name: String.t(),
    tag: String.t()
  }

  defstruct [:tag, :name, :clan_level, :badge_urls, :members]

  def format(clan) do
    {badges, clan} = Map.pop(clan, "badgeUrls")
    {members, clan} = Map.pop(clan, "members")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(clan, __MODULE__) |
      badge_urls: ExClash.HTTP.resp_to_struct(badges, ExClash.Badges),
      members: Enum.map(members, &ExClash.HTTP.resp_to_struct(&1, ExClash.WarLeaguePlayer))
    }
  end
end
