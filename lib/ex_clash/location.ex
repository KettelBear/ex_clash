defmodule ExClash.Location do
  # TODO: Some documentation to do in this file.
  @moduledoc """
  
  """

  alias ExClash.Type.Location, as: LocationType

  @doc """
  
  """
  @spec list(opts :: Keyword.t()) :: {list(LocationType.t()), ExClash.Paging.t()} | {:error, atom()}
  def list(opts \\ []) do
    case ExClash.HTTP.get("/locations", opts) do
      {:ok, %{"items" => items, "paging" => pagination}} ->
        {ExClash.cell_map_to_struct(items, LocationType), ExClash.Paging.format(pagination)}

      err ->
        err
    end
  end
end
