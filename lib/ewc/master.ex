defmodule Ewc.Master do
  alias Ewc.Slave

  def count(files) do
    sizes = files
    |> Enum.map(&process_file/1)
    |> Enum.map(&Task.await/1)

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

  defp process_file(file) do
    Task.async(fn -> {file, Slave.count(file)} end)
  end
end
