defmodule ExClash.Paging do
  @type t() :: %__MODULE__{after: String.t(), before: String.t()}

  defstruct after: nil, before: nil

  def format(%{"cursors" => cursors}) do
    %__MODULE__{
      after: Map.get(cursors, "after"),
      before: Map.get(cursors, "before")
    }
  end
end
