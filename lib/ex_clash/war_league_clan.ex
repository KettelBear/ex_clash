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

  # TODO:
  @doc """
  
  """
  @spec format(clan :: ExClash.cell_map() | list(ExClash.cell_map()) | nil)
      :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil

  def format(clan) when is_list(clan), do: Enum.map(clan, &format/1)

  def format(clan) do
    {badges, clan} = Map.pop(clan, "badgeUrls")
    {members, clan} = Map.pop(clan, "members")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(clan, __MODULE__) |
      badge_urls: ExClash.HTTP.resp_to_struct(badges, ExClash.Badges),
      members: ExClash.HTTP.resp_to_struct(members, ExClash.WarLeaguePlayer)
    }
  end
end
