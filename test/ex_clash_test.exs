defmodule ExClashTest do
  use ExUnit.Case
  doctest ExClash

  test "Ensures the base URL contains 'clashofclans'" do
    assert ExClash.base_url() |> String.contains?("clashofclans")
  end
end
