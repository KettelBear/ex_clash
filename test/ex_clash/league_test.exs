defmodule ExClash.LeagueTest do
  use ExClash.Case, async: true

  alias ExClash.Paging
  alias ExClash.League

  test "Gets league information for a limited response" do
    {
      [%League{}, %League{}, %League{}],
      %Paging{}
    } = League.list(plug: plug("mock_league_list.json"))
  end

  # TODO: These tests
  # builder_list
  # builder_one
  # one
  # seasons
  # top_players
end
