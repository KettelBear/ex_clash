defmodule ExClash.ChatLanguage do
  @moduledoc false

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    language_code: String.t()
  }

  defstruct [:id, :name, :language_code]
end
