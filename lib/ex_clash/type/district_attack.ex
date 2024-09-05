defmodule ExClash.Type.DistrictAttack do
  @moduledoc """
  The District Attack module.

  Attributes:

    * `attacker` - The name and tag of the attacker.
    * `destruction_percent` - The percent achieved by the attacker.
    * `stars` - How many stars obtained by the attacker.
  """

  @behaviour ExClash.Type

  @type t :: %__MODULE__{
    attacker: %{name: String.t(), tag: String.t()},
    destruction_percent: integer(),
    stars: integer()
  }

  defstruct [:attacker, :destruction_percent, :stars]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    attacker = Map.get(data, "attacker")

    %__MODULE__{
      attacker: %{name: Map.get(attacker, "name"), tag: Map.get(attacker, "tag")},
      destruction_percent: Map.get(data, "destructionPercent"),
      stars: Map.get(data, "stars")
    }
  end
end
