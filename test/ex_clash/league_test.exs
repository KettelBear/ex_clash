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
end
