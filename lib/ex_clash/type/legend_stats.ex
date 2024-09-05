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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    %__MODULE__{
      legend_trophies: Map.get(data, "legendTrophies"),
      best_season: data |> Map.get("bestSeason") |> Season.format(),
      current_season: data |> Map.get("currentSeason") |> Season.format(),
      previous_season: data |> Map.get("previousSeason") |> Season.format(),
      best_builder_season: data |> Map.get("bestBuilderBaseSeason") |> Season.format(),
      previous_builder_season: data |> Map.get("previousBuilderBaseSeason") |> Season.format(),
    }
  end
end
