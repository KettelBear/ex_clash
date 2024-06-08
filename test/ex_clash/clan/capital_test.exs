defmodule ExClash.CapitalTest do
  use ExUnit.Case, async: true

  alias ExClash.Capital
  alias ExClash.League
  alias ExClash.Paging

  test "Gets the specific league when provided an ID" do
    id = :rand.uniform(99999999)
    name = Faker.Person.name()

    plug = &Req.Test.json(&1, %{"id" => id, "name" => name})

    actual = Capital.leagues(id: id, plug: plug)

    assert %League{id: id, name: name, icon_urls: nil} == actual
  end

  test "Makes a request to get the capital leagues" do
    id = :rand.uniform(99999999)
    name = Faker.Person.name()

    response = %{
      "items" => [%{"id" => id, "name" => name}],
      "paging" => %{"cursors" => %{"after" => nil, "before" => nil}}
    }

    {items, paging} = Capital.leagues(plug: &Req.Test.json(&1, response))

    assert %Paging{after: nil, before: nil} == paging

    assert [%League{id: id, name: name, icon_urls: nil}] == items
  end
end
