defmodule ExClash.Type.WarClan do
  @moduledoc """
  """

  @behaviour ExClash.Type

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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {api_players, data} = Map.pop(data, "members")
    {badges, data} = Map.pop(data, "badgeUrls")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      badge_urls: ExClash.Type.Badges.format(badges),
      members: ExClash.Type.WarPlayer.format(api_players),
    }
  end
end
