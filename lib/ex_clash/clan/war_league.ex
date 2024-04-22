defmodule ExClash.Clan.WarLeague do
  @moduledoc """
  /clans/{clanTag}/currentwar/leaguegroup
  /clanwarleagues/wars/{warTag}
  """

  @spec league_group(clan_tag :: String.t()) :: map()
  def league_group(_clan_tag) do
   %{}
  end
end
