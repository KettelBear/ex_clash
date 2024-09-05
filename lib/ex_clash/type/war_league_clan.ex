defmodule ExClash.Type.WarLeagueClan do
  @moduledoc """
  The Clan struct specific to Clan War Leagues.
  """

  @behaviour ExClash.Type

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
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {badges, data} = Map.pop(data, "badgeUrls")
    {members, data} = Map.pop(data, "members")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      badge_urls: ExClash.Type.Badges.format(badges),
      members: ExClash.Type.WarLeaguePlayer.format(members)
    }
  end
end
