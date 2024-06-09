defmodule ExClash.RaidMember do
  @moduledoc """
  The Raid Member struct.

  This raid member belongs to the clan for which the raid season was queried
  for. In other words, the raid season was searched based on clan tag, and
  this raid member belongs to that clan.
  """

  @type t :: %__MODULE__{
    attack_limit: integer(),
    attacks: integer(),
    bonus_attack_limit: integer(),
    capital_resources_looted: integer(),
    name: String.t(),
    tag: String.t()
  }

  defstruct [
    :attack_limit,
    :attacks,
    :bonus_attack_limit,
    :capital_resources_looted,
    :name,
    :tag
  ]

  def format(members) when is_list(members) do
    Enum.map(members, &format/1)
  end

  def format(api_member) do
    ExClash.HTTP.resp_to_struct(api_member, __MODULE__)
  end
end
