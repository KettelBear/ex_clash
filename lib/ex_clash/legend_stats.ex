defmodule ExClash.LegendStats do
  @moduledoc """
  The Legend Statistics struct.
  """

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

  @spec format(stats :: ExClash.cell_map()) :: __MODULE__.t()
  def format(stats) do
    %__MODULE__{
      legend_trophies: Map.get(stats, "legendTrophies"),
      best_season: format_season(stats, "bestSeason"),
      current_season: format_season(stats, "currentSeason"),
      previous_season: format_season(stats, "previousSeason"),
      best_builder_season: format_season(stats, "bestBuilderBaseSeason"),
      previous_builder_season: format_season(stats, "previousBuilderBaseSeason"),
    }
  end

  defp format_season(stats, key) do
    case Map.get(stats, key) do
      nil -> nil
      season -> ExClash.HTTP.resp_to_struct(season, ExClash.Season)
    end
  end
end
