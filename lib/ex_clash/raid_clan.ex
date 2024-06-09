defmodule ExClash.RaidClan do
  @moduledoc """
  The Raid Clan struct.
  """

  @type t :: %__MODULE__{
    badge_urls: ExClash.IconUrls.t(),
    level: integer(),
    name: String.t(),
    tag: String.t()
  }

  defstruct [
    :badge_urls,
    :level,
    :name,
    :tag
  ]

  def format(api_clan) do
    {badges, api_clan} = Map.pop(api_clan, "badgeUrls")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.HTTP.resp_to_struct(badges, ExClash.Badges)
    }
  end
end
