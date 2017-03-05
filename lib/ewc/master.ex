defmodule Ewc.Master do
  alias Ewc.Slave

  @initial_state %{chars: 0, words: 0, lines: 0}

  def count(file, opts \\ []) do
    file
    |> File.stream!
    |> map_file
    |> reduce_result
  end

  def map_file(file_stream) do
    Enum.map(file_stream, &Slave.process_line/1)
  end

  def reduce_result(result_list) do
    Enum.reduce(result_list, @initial_state, fn(curr, acc) ->
      acc
      |> Map.merge(curr, fn(_key, v1, v2) -> v1 + v2 end)
      |> Map.update!(:lines, fn v -> v + 1 end)
    end)
  end
end
