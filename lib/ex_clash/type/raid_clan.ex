defmodule ExClash.Type.RaidClan do
  @moduledoc """
  The Raid Clan struct.
  """

  @behaviour ExClash.Type

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

  @spec format(cell_clan :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_clan) do
    {badges, cell_clan} = Map.pop(cell_clan, "badgeUrls")

    %__MODULE__{
      ExClash.cell_map_to_struct(cell_clan, __MODULE__) |
      badge_urls: ExClash.cell_map_to_struct(badges, ExClash.Type.Badges)
    }
  end
end
