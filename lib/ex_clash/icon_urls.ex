defmodule ExClash.IconUrls do
  @moduledoc """
  The IconUrls struct.

  These are the URLs for the various icons that belong to leagues and labels.

  Attributes:

    * `tiny` - The URL leading to the tiny icon.

    * `small` - The URL leading to the small icon.

    * `medium` - The URL leading to the medium icon.

    * `large` - The URL leading to the large icon.
  """

  @type t() :: %__MODULE__{
    tiny: String.t(),
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:tiny, :small, :medium, :large]
end
