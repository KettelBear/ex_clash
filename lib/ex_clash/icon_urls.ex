defmodule ExClash.IconUrls do
  @moduledoc """
  """

  @type t() :: %__MODULE__{
    tiny: String.t(),
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:tiny, :small, :medium, :large]
end
