defmodule Ewc.Slave do
  def process_line(line) do
    result = %{}

    result
    |> add_char_count(line)
    |> add_word_count(line)
  end

  defp add_char_count(result, line), do: Map.put(result, :chars, count_chars(line))
  defp add_word_count(result, line), do: Map.put(result, :words, count_words(line)) 

  defp count_chars(line), do: String.length(line)
  defp count_words(line), do: line |> String.split |> Enum.count
end
