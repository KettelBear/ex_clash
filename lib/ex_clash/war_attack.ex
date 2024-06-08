defmodule ExClash.WarAttack do
  @moduledoc """
  A player's attack in war.
  """

  @typedoc """
  """
  @type t() :: %__MODULE__{
    attacker_tag: String.t(),
    defender_tag: String.t(),
    destruction_percentage: integer(),
    duration: integer(),
    order: integer(),
    stars: integer()
  }

  defstruct [
    :attacker_tag,
    :defender_tag,
    :destruction_percentage,
    :duration,
    :order,
    :stars
  ]
end
