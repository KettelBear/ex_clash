defmodule ExClash.Type do
  @moduledoc """
  The `Type` behaviour.

  Responses from Supercell are specifically formatted responses from their API.
  Each of those should map, 1 to 1, to a `Type` here in this project. The only
  exception to this rule is when there is nearly identicle overlap.
  """

  @typedoc """
  The input type for the `format` callback.
  """
  @type cell_input() :: ExClash.cell_map() | list(ExClash.cell_map) | nil

  @callback format(cell_map :: cell_input()) :: any()
end
