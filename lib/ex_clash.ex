defmodule ExClash do
  @moduledoc """
  Although the top level module, this doesn't do a lot of work. The idea is to
  capture the behaviours and data in the structs associated with the different
  aspects of the game. Look to `ExClash.Clan` for clan based calls to get back
  the clan struct, and to `ExClash.Player` for player calls and information,
  and so on.
  """

  @typedoc """
  A map with camelCase string keys.

  The response that comes back from Supercell and is decoded by `Jason`.
  """
  @type cell_map() :: map()

  @typedoc """
  A string that starts with `#`.

  These tags are used in Supercell's system for identifying players, clans,
  and wars.

  ## Examples

      #1234ABDCD

      #RUJSDL432
  """
  @type tag() :: String.t()

  @typedoc """
  An atom to determine the home village or builder base.
  """
  @type village() :: :home | :builder

  @doc """
  Changes a camelCase string to a snake_case atom.

  Translates the camelCase from an API JSON response body into an atom that is
  snake case to follow Elixir convention. Generally, these occur for the keys
  of the response body, and any values that are enums.

  ## Examples

      iex> ExClash.camel_to_atom("camelCase")
      :camel_case
  """
  @spec camel_to_atom(camel :: String.t()) :: atom()
  def camel_to_atom(camel), do: camel |> Macro.underscore() |> String.to_atom()
end
