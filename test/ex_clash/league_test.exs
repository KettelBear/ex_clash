defmodule ExClash.LeagueTest do
  use ExClash.Case, async: true

  alias ExClash.HTTP.Paging
  alias ExClash.League
  alias ExClash.Type.League, as: LeagueStruct

  test "Gets league information for a limited response" do
    {
      [%LeagueStruct{}, %LeagueStruct{}, %LeagueStruct{}],
      %Paging{}
    } = League.home_leagues(plug: plug("mock_league_list.json"))
  end

  # TODO: These tests
  # builder_list
  # builder_one
  # one
  # seasons
  # top_players
end
