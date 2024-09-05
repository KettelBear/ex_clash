defmodule ExClash.Type do
  # TODO: This documentation
  @moduledoc """

  """

  @typedoc """
  
  """
  @type cell_input() :: ExClash.cell_map() | list(ExClash.cell_map) | nil

  @callback format(cell_map :: cell_input()) :: any()
end
