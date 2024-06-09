defmodule ExClash.DistrictAttack do
  @moduledoc """
  The District Attack module.
  """

  @type t :: %__MODULE__{
    attacker: %{name: String.t(), tag: String.t()},
    destruction_percent: integer(),
    stars: integer()
  }

  defstruct [
    :attacker,
    :destruction_percent,
    :stars
  ]

  @spec format(api_attack :: ExClash.cell_map()) :: __MODULE__.t()
  def format(nil), do: nil

  def format(attacks) when is_list(attacks), do: Enum.map(attacks, &format/1)

  def format(api_attack) do
    attacker = Map.get(api_attack, "attacker")

    %__MODULE__{
      attacker: %{name: Map.get(attacker, "name"), tag: Map.get(attacker, "tag")},
      destruction_percent: Map.get(api_attack, "destructionPercent"),
      stars: Map.get(api_attack, "stars")
    }
  end
end
