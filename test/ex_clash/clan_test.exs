defmodule ExClash.ClanTest do
  use ExUnit.Case, async: true

  alias ExClash.Clan
  alias ExClash.WarLeague
  alias ExClash.WarLeague.Clan, as: WarClan
  alias ExClash.WarLeague.Rounds

  test "Get the CWL Group" do
    %WarLeague{
      clans: [%WarClan{} | _],
      rounds: %Rounds{}
    } = Clan.cwl_group("Should be a clan tag", plug: &Req.Test.json(&1, mock("mock_cwl_group.json")))
  end

  test "Get the clan details from the API" do
    %{"tag" => tag} = mock = mock("mock_clan.json")

    # There is a lot of information that could be validated here, A LOT.
    %Clan{tag: ^tag} = Clan.details(tag, plug: &Req.Test.json(&1, mock))
  end

  defp mock(file) do
    Path.join(["test", "data", file])
    |> File.read!()
    |> Jason.decode!()
  end
end
