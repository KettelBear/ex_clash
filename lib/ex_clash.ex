defmodule ExClash do
  @moduledoc """
  Although the top level module, this doesn't do a lot of work. The idea is to
  capture the behaviours and data in the structs associated with the different
  aspects of the game. Look to `ExClash.Clan` for clan based calls to get back
  the clan struct, and to `ExClash.Player` for player calls and information,
  and so on and so on.
  """

  @doc """
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
