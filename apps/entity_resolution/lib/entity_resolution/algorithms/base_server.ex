defmodule EntityResolution.Algorithms.BaseServer do
  defmacro __using__(_opts) do
    quote do
      use GenServer

      def start_link(_) do
        GenServer.start_link(__MODULE__, servers(), name: __MODULE__)
      end

      def get_next_server do
        GenServer.call(__MODULE__, :get_next_server)
      end

      defp servers do
        :entity_resolution
        |> Application.fetch_env!(:workers)
        |> Enum.map(fn {k, v} -> %{name: k, weight: v} end)
      end
    end
  end
end
