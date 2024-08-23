defmodule ExClash do
  @moduledoc """
  Although the top level module, this doesn't do a lot of work.

  The idea is to capture the behaviours and data in the structs associated with
  the different aspects of the game. Look to `ExClash.Clan` for clan based calls
  to get back the clan struct, and to `ExClash.Player` for player calls and
  information, and so on.
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
  @type tag() :: binary()

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
  @spec camel_to_atom(camel :: String.t() | nil) :: atom() | nil
  def camel_to_atom(nil), do: nil
  def camel_to_atom(camel), do: camel |> Macro.underscore() |> String.to_atom()

  @doc """
  Covert `ExClash.cell_map()` to the `clash_struct`.

  The response body from the HTTP request is JSON. This will handle converting
  the keys into snake case atoms, then put them in the `clash_struct`. Since
  the struct needs to be passed in, it is not recursive.

  ## Examples

      iex> ExClash.cell_map_to_struct(%{"myHTTPKey" => "Some value"}, ExampleStruct)
      %ExampleStruct{my_api_key: "Some value"}

      iex> my_list = [%{"myApiKey" => "Some value"}, %{"myApiKey" => "Other value"}]
      iex> ExClash.cell_map_to_struct(my_list, ExampleStruct)
      [%ExampleStruct{my_api_key: "Some value"}, %ExampleStruct{my_api_key: "Other value"}]
  """
  @spec cell_map_to_struct(cell_map :: cell_map() | list(cell_map()) | nil, clash_struct :: atom())
      :: struct() | list(struct()) | nil
  def cell_map_to_struct(nil, _clash_struct), do: nil

  def cell_map_to_struct(cell_map, clash_struct) when is_list(cell_map) do
    Enum.map(cell_map, &cell_map_to_struct(&1, clash_struct))
  end

  def cell_map_to_struct(cell_map, clash_struct) do
    Map.new(cell_map, fn
      {"village", "home"} -> {:village, :home}
      {"village", _} -> {:village, :builder}
      {"role", "admin"} -> {:role, :elder}
      {"role", role} -> {:role, ExClash.camel_to_atom(role)}
      {key, value} -> {ExClash.camel_to_atom(key), maybe_datetime(value)}
    end)
    |> then(&struct(clash_struct, &1))
  end

  defp maybe_datetime(string) when is_binary(string) do
    if String.ends_with?(string, ".000Z"), do: convert_time(string), else: string
  end
  defp maybe_datetime(not_string), do: not_string

  defp convert_time(time_string) do
    time_string
    |> DateTime.from_iso8601(:basic)
    |> case do
      {:ok, datetime, _} -> datetime
      _ -> {:error, :invalid_datetime}
    end
  end
end
