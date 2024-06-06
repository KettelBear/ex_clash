defmodule ExClash.ClanTest do
  use ExUnit.Case, async: true

  alias ExClash.Clan
  alias ExClash.Paging
  alias ExClash.WarLeague
  alias ExClash.WarLeague.Clan, as: WarClan
  alias ExClash.WarLeague.Rounds

  test "Get the CWL Group" do
    %WarLeague{
      clans: [%WarClan{} | _],
      rounds: %Rounds{}
    } = Clan.cwl_group("Should be a clan tag", plug: plug("mock_cwl_group.json"))
  end

  test "Search returns a list of possible clans" do
    {
      [%Clan{}, %Clan{}, %Clan{}, %Clan{}, %Clan{}],
      %Paging{}
    } = Clan.search(
      name: "My Clan",
      min_clan_level: 10,
      min_members: 25,
      limit: 5,
      plug: plug("mock_search_results.json")
    )
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

  defp plug(file), do: &Req.Test.json(&1, mock(file))
end
