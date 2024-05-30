defmodule ExClashTest do
  use ExUnit.Case

  test "converts camelCase strings to snake_case atoms" do
    assert ExClash.camel_to_atom("camelCaseString") == :camel_case_string
  end
end
