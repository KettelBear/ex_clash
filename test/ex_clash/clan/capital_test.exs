defmodule ExClash.Clan.CapitalTest do
  use ExUnit.Case

  alias ExClash.Clan.Capital

  test "Makes a request to get the capital leagues" do
    id = :rand.uniform(99999999)
    name = Faker.Person.name()

    response = %{
      "items" => [%{"id" => id, "name" => name}],
      "paging" => %{"cursors" => %{"after" => nil, "before" => nil}}
    }

    {items, paging} = Capital.leagues(plug: &Req.Test.json(&1, response))

    assert %ExClash.Paging{after: nil, before: nil} == paging

    assert [%ExClash.League{id: id, name: name, icon_urls: nil}] == items
  end
end
