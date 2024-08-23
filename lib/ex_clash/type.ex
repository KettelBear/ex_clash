defmodule ExClash.Type do
  @callback format(cell_map :: ExClash.cell_map()) :: any()
end
