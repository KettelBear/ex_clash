defmodule ExClash.Hero do
  @moduledoc """
  The Hero struct.
    %{
      "equipment" => [
        %{
          "level" => 18,
          "maxLevel" => 18,
          "name" => "Haste Vial",
          "village" => "home"
        },
        %{
          "level" => 18,
          "maxLevel" => 18,
          "name" => "Royal Gem",
          "village" => "home"
        }
      ],
      "level" => 45,
      "maxLevel" => 45,
      "name" => "Royal Champion",
      "village" => "home"
    },
    %{
      "level" => 35,
      "maxLevel" => 35,
      "name" => "Battle Copter",
      "village" => "builderBase"
    }
  ],
  """

  # TODO: Create the type for the struct. And to continue from there, I'll need to create the equipment struct.

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village(),
    equipment: list(ExClash.Equipment.t())
  }

  defstruct [:name, :level, :max_level, :village, :equipment]

  def format(api_hero) do
    {equipment, api_hero} = Map.pop(api_hero, "equipment")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_hero, __MODULE__) |
      equipment: format_equipment(equipment)
    }
  end

  defp format_equipment(nil), do: nil
  defp format_equipment(pieces) do
    Enum.map(pieces, &ExClash.HTTP.resp_to_struct(&1, ExClash.Equipment))
  end
end
