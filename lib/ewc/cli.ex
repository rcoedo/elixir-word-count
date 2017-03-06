defmodule Ewc.CLI do
  alias Ewc.Master

  @aliases [m: :chars, l: :lines, w: :words]
  @switches [chars: :boolean, lines: :boolean, words: :boolean]
  @default_opts [lines: true, words: true, chars: true]
  @empty_opts [lines: false, words: false, chars: false]

  def main(args) do
    {flags, files, _invalid} = parse_args(args)
    opts = merge_defaults(flags)

    files
    |> process_files
    |> print_output(opts)
  end

  defp merge_defaults([]), do: @default_opts
  defp merge_defaults(flags), do: Keyword.merge(@empty_opts, flags)

  defp parse_args(args) do
    args
    |> OptionParser.parse(aliases: @aliases, switches: @switches)
  end

  defp process_files(files) do
    sizes = Master.count(files)
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

  defp print_line({tag, %{lines: lines, words: words, chars: chars}}, opts) do
    if Keyword.get(opts, :lines), do: IO.write "\t#{lines}"
    if Keyword.get(opts, :words), do: IO.write "\t#{words}"
    if Keyword.get(opts, :chars), do: IO.write "\t#{chars}"
    IO.puts "\t#{tag}"
  end

  defp print_output({sizes, total}, opts) do
    Enum.map(sizes, fn(size) -> print_line(size, opts) end)
    if Enum.count(sizes) > 1 do
      print_line({"total", total}, opts)
    end
  end
end
