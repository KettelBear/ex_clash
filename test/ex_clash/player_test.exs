defmodule ExClash.PlayerTest do
  use ExClash.Case, async: true

  alias ExClash.Player
  alias ExClash.Type.Player, as: PlayerStruct

  test "Get the player details from the API" do
    %{"tag" => tag} = mock = mock("mock_player.json")

    # There is a lot of information that could be validated here, A LOT.
    %PlayerStruct{tag: ^tag} = Player.details(tag, plug: &Req.Test.json(&1, mock))
  end
end
