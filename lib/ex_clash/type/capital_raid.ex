defmodule ExClash.Type.CapitalRaid do
  @moduledoc """
  The Capital Raid module.

  The shape of the individual raids for each raid accomplished during the
  raid weekend. So, the `ExClash.RaidClan` could be an attacker or a
  defender, but will never be the name of the clan that was queried for.

  If the log was acquired from the attack log, then the `clan` in that
  instance is the clan that was attacked. And if acquired from the defense
  log, then it is the clan that did the attacking.

  Here is an example:
  * Clan A: Cookies & Milk
  * Clan B: Peanut Butter
  * Clan C: Pineapple Belongs on Pizza

  Querying for Cookies & Milk's raid season history will result in the
  following information. In the attack log, Cookies & Milk attacked
  Peanut Butter, and therefore, the `clan` will be populated with
  Peanut Butter's information. However, in the defense log, Pineapple
  Belongs on Pizza attacked Cookies & Milk, therefore Pineapple Belongs
  on Pizza's information will be in the `clan` key.
  """

  @behaviour ExClash.Type

  @type t :: %__MODULE__{
    attack_count: integer(),
    clan: ExClash.RaidClan.t(),
    district_count: integer(),
    districts: ExClash.DistrictRaid.t(),
    districts_destroyed: integer(),
  }

  defstruct [
    :attack_count,
    :clan,
    :district_count,
    :districts,
    :districts_destroyed
  ]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(%{"attacker" => _} = data) do
    {clan, data} = Map.pop(data, "attacker")
    {districts, data} = Map.pop(data, "districts")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      clan: ExClash.Type.RaidClan.format(clan),
      districts: ExClash.Type.DistrictRaid.format(districts)
    }
  end
  def format(%{"defender" => _} = data) do
    {clan, data} = Map.pop(data, "defender")
    {districts, data} = Map.pop(data, "districts")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      clan: ExClash.Type.RaidClan.format(clan),
      districts: ExClash.Type.DistrictRaid.format(districts)
    }
  end
end
