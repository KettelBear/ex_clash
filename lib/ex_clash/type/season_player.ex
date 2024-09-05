defmodule ExClash.Type.SeasonPlayer do
  @moduledoc """
  The Season Player struct.

  Note that to get this struct, an API call will have been made which included
  the desired season. This is being mentioned because the season for which this
  player belongs is not included in this struct.

  Attributes:

    * `attack_wins` - The number of wins the player achieved for the season.
    * `clan_name` - The name of the clan to which the player belonged.
    * `clan_tag` - The tag of the clan to which the player belonged.
    * `defense_wins` - The number of defensive wins the player achieved.
    * `exp_level` - The level of the player.
    * `name` - The player's village name.
    * `rank` - The ranked earned by the player for the season.
    * `tag` - The player's `ExClash.tag()`.
    * `trophies` - The player's total earned trophies.
  """

  @behaviour ExClash.Type

  @type t :: %__MODULE__{
    attack_wins: integer(),
    clan_name: String.t(),
    clan_tag: ExClash.tag(),
    defense_wins: integer(),
    exp_level: integer(),
    name: String.t(),
    rank: integer(),
    tag: ExClash.tag(),
    trophies: integer()
  }

  defstruct [
    :attack_wins,
    :clan_name,
    :clan_tag,
    :defense_wins,
    :exp_level,
    :name,
    :rank,
    :tag,
    :trophies
  ]

  @doc """
  Format the API response for the Season Player.
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {%{"name" => clan_name, "tag" => clan_tag}, data} = Map.pop(data, "clan")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      clan_name: clan_name,
      clan_tag: clan_tag
    }
  end
end
