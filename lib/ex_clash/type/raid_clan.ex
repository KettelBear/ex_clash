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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {badges, data} = Map.pop(data, "badgeUrls")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      badge_urls: ExClash.cell_map_to_struct(badges, ExClash.Type.Badges)
    }
  end
end
