defmodule ExClash.HTTP.Paging do
  @moduledoc """
  The Paging struct.

  For calls that may be paginated, the response will from the function will be
  a tuple in the form of `{[DATA], %ExClash.HTTP.Paging{}}`.

  Attributes:

    * `after` - Marker to fetch results after the current dataset.
    * `before` - Marker to fetch results before the current dataset.
  """

  @type t() :: %__MODULE__{after: String.t(), before: String.t()}

  defstruct [after: nil, before: nil]

  @doc """
  Handles the parsing of the pagination parameters.
  """
  @spec format(api_paging :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(%{"cursors" => nil}), do: nil
  def format(%{"cursors" => cursors}) do
    %__MODULE__{
      after: Map.get(cursors, "after"),
      before: Map.get(cursors, "before")
    }
  end
end
