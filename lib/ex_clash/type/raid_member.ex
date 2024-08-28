defmodule ExClash.Type.RaidMember do
  @moduledoc """
  The Raid Member struct.

  This raid member belongs to the clan for which the raid season was queried
  for. In other words, the raid season was searched based on clan tag, and
  this raid member belongs to that clan.
  """

  @behaviour ExClash.Type

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

  @spec format(cell_member :: ExClash.cell_map() | list(ExClash.cell_map()) | nil) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(cell_member) when is_list(cell_member), do: Enum.map(cell_member, &format/1)
  def format(cell_member), do: ExClash.cell_map_to_struct(cell_member, __MODULE__)
end
