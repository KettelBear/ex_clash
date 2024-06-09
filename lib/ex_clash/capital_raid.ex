defmodule ExClash.CapitalRaid do
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

  def format(raids) when is_list(raids) do
    Enum.map(raids, &format/1)
  end

  def format(%{"attacker" => _} = api_raid) do
    {clan, api_raid} = Map.pop(api_raid, "attacker")
    {districts, api_raid} = Map.pop(api_raid, "districts")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_raid, __MODULE__) |
      clan: ExClash.RaidClan.format(clan),
      districts: ExClash.DistrictRaid.format(districts)
    }
  end

  def format(%{"defender" => _} = api_raid) do
    {clan, api_raid} = Map.pop(api_raid, "defender")
    {districts, api_raid} = Map.pop(api_raid, "districts")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_raid, __MODULE__) |
      clan: ExClash.RaidClan.format(clan),
      districts: ExClash.DistrictRaid.format(districts)
    }
  end
end
