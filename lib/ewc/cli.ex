defmodule Ewc.CLI do
  alias Ewc.Master

  @aliases [m: :chars, l: :lines, w: :words]
  @switches [chars: :boolean, lines: :boolean, words: :boolean]
  @default_flags [lines: true, words: true, chars: true]
  @empty_flags [lines: false, words: false, chars: false]

  def main(args) do
    options =
      args
      |> parse_args
      |> process_args

    case options do
      {flags, [], _invalid} -> print_help()
      {flags, files, []}-> process_files(files, flags)
      _ -> print_help()
    end
  end

  defp parse_args(args), do: OptionParser.parse(args, aliases: @aliases, switches: @switches)
  defp process_args({flags, files, invalid}), do: {merge_defaults(flags), files, invalid}

  defp merge_defaults([]), do: @default_flags
  defp merge_defaults(flags), do: Keyword.merge(@empty_flags, flags)

  defp process_files(files, flags) do
    files
    |> Master.count
    |> print_output(flags)
  end

  defp print_line({tag, %{lines: lines, words: words, chars: chars}}, flags) do
    if Keyword.get(flags, :lines), do: IO.write "\t#{lines}"
    if Keyword.get(flags, :words), do: IO.write "\t#{words}"
    if Keyword.get(flags, :chars), do: IO.write "\t#{chars}"
    IO.puts "\t#{tag}"
  end

  defp print_output({sizes, total}, flags) do
    Enum.map(sizes, fn(size) -> print_line(size, flags) end)
    if Enum.count(sizes) > 1 do
      print_line({"total", total}, flags)
    end
  end

  defp print_help do
    IO.puts "ewc usage: ewc [-lmw] [file ...]"
  end
end
