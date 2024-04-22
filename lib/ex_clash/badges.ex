defmodule ExClash.Badges do
  @moduledoc false

  @type t() :: %__MODULE__{
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:small, :medium, :large]
end
