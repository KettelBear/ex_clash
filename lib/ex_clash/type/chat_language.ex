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

  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data), do: ExClash.cell_map_to_struct(data, __MODULE__)
end
