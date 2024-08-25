defmodule ExClash.Type.WarLeagueRounds do
  @moduledoc """
  The War League Round struct.

  Attributes:

    * `one` - The list of war tags for the first day.
    * `two` - The list of war tags for the second day.
    * `three` - The list of war tags for the third day.
    * `four` - The list of war tags for the fourth day.
    * `five` - The list of war tags for the fifth day.
    * `six` - The list of war tags for the sixth day.
    * `seven` - The list of war tags for the seventh day.
  """

  @behaviour ExClash.Type

  @typedoc """
  A list of War Tags.
  """
  @type round() :: list(ExClash.tag())

  @type t() :: %__MODULE__{
    one: list(ExClash.tag()),
    two: list(ExClash.tag()),
    three: list(ExClash.tag()),
    four: list(ExClash.tag()),
    five: list(ExClash.tag()),
    six: list(ExClash.tag()),
    seven: list(ExClash.tag())
  }

  defstruct [:one, :two, :three, :four, :five, :six, :seven]

  @spec format(cell_rounds :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(rounds), do: format(%{}, rounds, [:one, :two, :three, :four, :five, :six, :seven])

  defp format(map, [], []), do: struct(WarLeagueRounds, map)
  defp format(map, [%{"warTags" => tags} | rounds], [rnd_num | nums]) do
    map
    |> Map.put(rnd_num, tags)
    |> format(rounds, nums)
  end
end
