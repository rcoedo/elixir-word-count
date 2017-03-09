defmodule Ewc.Slave do
  @initial_state %{chars: 0, words: 0, lines: 0}

  def count(file) do
    file
    |> File.stream!
    |> count_lines
    |> reduce_result
  end

  defp count_lines(file_stream), do: Stream.map(file_stream, &process_line/1)

  defp reduce_result(result) do
    Enum.reduce(result, @initial_state, fn(curr, acc) ->
      acc
      |> Map.merge(curr, fn(_key, v1, v2) -> v1 + v2 end)
      |> Map.update!(:lines, fn v -> v + 1 end)
    end)
  end

  defp process_line(line) do
    %{}
    |> add_char_count(line)
    |> add_word_count(line)
  end

  defp add_char_count(result, line), do: Map.put(result, :chars, String.length(line))
  defp add_word_count(result, line), do: Map.put(result, :words, line |> String.split |> Enum.count)
end
