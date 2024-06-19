defmodule ExClash.ChatLanguage do
  @moduledoc """
  The ChatLanguage struct.

  Attributes:

    * `id` - The integer identifier of the chat langauge.
    * `name` - The name of the language.
    * `language_code` - The 2-letter code.
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    language_code: String.t()
  }

  defstruct [:id, :name, :language_code]
end
