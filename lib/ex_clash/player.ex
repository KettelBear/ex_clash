defmodule ExClash.Player do
  # TODO:
  @moduledoc """
  
  """

  alias ExClash.Type.Player, as: PlayerStruct

  @doc """
  Retrieve the player details for the provided clan `tag`.

  ## Parameters

    * `tag` - The player tag to look up.
    * `opts` - Additional `Req` options.

  ## Examples

      iex> ExClash.Player.details("#QVRVCY28")
      %ExClash.Type.Player{tag: "#QVRVCY28", name: "Sean", ...}

      iex> ExClash.Player.details("#000000")
      {:error, :not_found}
  """
  @spec details(tag :: ExClash.tag(), opts :: Keyword.t()) :: PlayerStruct.t() | {:error, atom()}
  def details(tag, opts \\ []) do
    case ExClash.HTTP.get("/players/#{tag}", opts) do
      {:ok, player} -> PlayerStruct.format(player)
      err -> err
    end
  end
end
