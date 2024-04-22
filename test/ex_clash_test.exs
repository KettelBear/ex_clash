defmodule ExClashTest do
  use ExUnit.Case
  doctest ExClash

  test "Ensures the base URL contains 'clashofclans'" do
    assert ExClash.base_url() |> String.contains?("clashofclans")
  end

  test "Appends the path to the end of the url" do
    assert ExClash.url("/test") |> String.ends_with?("/test")
  end

  test "Tests encoding of tag" do
    assert ExClash.encode_tag("#test") == "%23test"
    assert ExClash.encode_tag("test") == "%23test"
  end
end
