defmodule ExClash.PlayerTest do
  use ExUnit.Case, async: true

  alias ExClash.Player

  test "Get the player details from the API" do
    %{"tag" => tag} = mock = mock_player()

    # There is a lot of information that could be validated here, A LOT.
    %Player{tag: ^tag} = Player.details(tag, plug: &Req.Test.json(&1, mock))
  end

  defp mock_player() do
    Path.join(["test", "data", "mock_player.json"])
    |> File.read!()
    |> Jason.decode!()
  end
end
