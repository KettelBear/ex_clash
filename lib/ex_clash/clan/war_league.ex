defmodule ExClash.Clan.WarLeague do
  @moduledoc false

  # This will be moved to its own module.
  @spec league_group(clan_tag :: String.t()) :: map()
  def league_group(clan_tag) do
    _ = "/clans/#{clan_tag}/currentwar/leaguegroup"
    %{}
  end
end
