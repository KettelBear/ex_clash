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

  defstruct [:name, :level, :max_level, :village, :equipment]
end
