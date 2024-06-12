ExUnit.start()
Faker.start()

defmodule ExClash.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      def mock(file) do
        Path.join(["test", "data", file])
        |> File.read!()
        |> Jason.decode!()
      end

      def plug(file), do: &Req.Test.json(&1, mock(file))
    end
  end
end
