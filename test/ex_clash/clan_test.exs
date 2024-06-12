defmodule ExClash.ClanTest do
  @moduledoc """
  Testing Clan Formatting (read details).

  I'm going to note the intent of this test file, since it is failing to
  validate a lot of specific information when performing the test of the
  function.

  The intent of these tests is to ensure that formatting does not break
  when receiving a map that was created from `Jason.decode/1`. The actual
  request is mocked, and the data comes from `test/data/` so there can be
  no data validation. I would merely be validating the data I told it to
  return. However, what is important, is that formatting does not break,
  and that the appropriate structs are returned.
  """

  use ExClash.Case, async: true

  alias ExClash.Clan
  alias ExClash.ClanMember
  alias ExClash.Paging
  alias ExClash.War
  alias ExClash.WarLeague
  alias ExClash.WarLeagueClan
  alias ExClash.WarLeague.Rounds

  test "Get the CWL Group" do
    %WarLeague{
      clans: [%WarLeagueClan{} | _],
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

  test "Get the clan members provided a clan tag" do
    {
      [%ClanMember{}, %ClanMember{}, %ClanMember{}, %ClanMember{}, %ClanMember{}],
      %Paging{}
    } = Clan.members("Should be a clan tag", plug: plug("mock_clan_members.json"))
  end

  test "Get the clan details from the API" do
    %{"tag" => tag} = mock = mock("mock_clan.json")

    # There is a lot of information that could be validated here, A LOT.
    %Clan{tag: ^tag} = Clan.details(tag, plug: &Req.Test.json(&1, mock))
  end

  describe "The clan has a public war log" do
    test "Get the war log for the provided clan tag" do
      {
        [%War{}, %War{}, %War{}, %War{}, %War{}],
        %Paging{}
      } = Clan.war_log("Should be a clan tag", plug: plug("mock_war_log.json"))
    end

    test "Get the current (or most recent) war for the clan tag" do
      # TODO: Do this when it is not CWL
      assert true
    end
  end
end
