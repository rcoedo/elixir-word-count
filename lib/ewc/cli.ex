defmodule Ewc.CLI do
  alias Ewc.Master

  @aliases [m: :chars, l: :lines, w: :words]
  @switches [chars: :boolean, lines: :boolean, words: :boolean]

  def main(args) do
    {options, files, _invalid} = parse_args(args)

    files
    |> process_files(options)
    |> print_output
  end

  defp parse_args(args) do
    args
    |> OptionParser.parse(aliases: @aliases, switches: @switches)
  end

  defp process_files(files, options) do
    sizes = Enum.map(files, fn(file) -> {file, Master.count(file, options)} end)
    total = calculate_total(sizes)

    {sizes, total}
  end

  defp calculate_total(sizes) do
    sizes
    |> Enum.map(fn {_file, size} -> size end)
    |> Enum.reduce(%{}, fn (acc, curr) ->
      Map.merge(acc, curr, fn(_key, v1, v2) -> v1 + v2 end)
    end)
  end

  defp print_sizes(sizes) do
    Enum.each(sizes, fn ({file, %{lines: lines, words: words, chars: chars}}) ->
      IO.puts("\t#{lines}\t#{words}\t#{chars}\t#{file}")
    end)
  end

  defp print_total(%{lines: lines, words: words, chars: chars}) do
    IO.puts("\t#{lines}\t#{words}\t#{chars}\ttotal")
  end

  defp print_output({sizes, total}) do
    print_sizes(sizes)
    if Enum.count(sizes) > 1 do
      print_total(total)
    end
  end
end
