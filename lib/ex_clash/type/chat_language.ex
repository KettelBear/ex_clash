defmodule ExClash.Type.ChatLanguage do
  @moduledoc """
  The ChatLanguage struct.

  Attributes:

    * `id` - The integer identifier of the chat langauge.
    * `name` - The name of the language.
    * `language_code` - The 2-letter code.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    language_code: String.t()
  }

  defstruct [:id, :name, :language_code]

  @spec format(cell_language :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_language), do: ExClash.cell_map_to_struct(cell_language, __MODULE__)
end
