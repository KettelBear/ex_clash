defmodule ExClash.CapitalTest do
  use ExClash.Case, async: true

  alias ExClash.HTTP.Paging
  alias ExClash.League
  alias ExClash.Type.League, as: LeagueStruct

  test "Gets the specific league when provided an ID" do
    id = :rand.uniform(99999999)
    name = Faker.Person.name()

    plug = &Req.Test.json(&1, %{"id" => id, "name" => name})

    actual = League.capital_league(id, plug: plug)

    assert %LeagueStruct{id: id, name: name, icon_urls: nil} == actual
  end

  test "Makes a request to get the capital leagues" do
    id = :rand.uniform(99999999)
    name = Faker.Person.name()

    response = %{
      "items" => [%{"id" => id, "name" => name}],
      "paging" => %{"cursors" => %{"after" => nil, "before" => nil}}
    }

    {items, paging} = League.capital_leagues(plug: &Req.Test.json(&1, response))

    assert %Paging{after: nil, before: nil} == paging

    assert [%LeagueStruct{id: id, name: name, icon_urls: nil}] == items
  end
end
