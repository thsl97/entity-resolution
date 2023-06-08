defmodule EntityResolutionWorkerTest do
  use ExUnit.Case
  doctest EntityResolutionWorker

  test "greets the world" do
    assert EntityResolutionWorker.hello() == :world
  end
end
