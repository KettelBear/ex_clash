defmodule ExClash.Type.LegendStats do
  @moduledoc """
  The Legend Statistics struct.
  """

  @behaviour ExClash.Type

  alias ExClash.Type.Season

  @type t() :: %__MODULE__{
    legend_trophies: integer(),
    best_season: ExClash.Season.t(),
    current_season: ExClash.Season.t(),
    previous_season: ExClash.Season.t(),
    best_builder_season: ExClash.Season.t(),
    previous_builder_season: ExClash.Season.t()
  }

  defstruct [
    # Home Village
    :best_season,
    :current_season,
    :legend_trophies,
    :previous_season,

    # Builder Base
    :best_builder_season,
    :previous_builder_season
  ]

  @spec format(cell_stats :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_stats) do
    %__MODULE__{
      legend_trophies: Map.get(cell_stats, "legendTrophies"),
      best_season: cell_stats |> Map.get("bestSeason") |> Season.format(),
      current_season: cell_stats |> Map.get("currentSeason") |> Season.format(),
      previous_season: cell_stats |> Map.get("previousSeason") |> Season.format(),
      best_builder_season: cell_stats |> Map.get("bestBuilderBaseSeason") |> Season.format(),
      previous_builder_season: cell_stats |> Map.get("previousBuilderBaseSeason") |> Season.format(),
    }
  end
end
