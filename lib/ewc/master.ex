defmodule Ewc.Master do
  alias Ewc.Slave

  def count(files) do
    files
    |> Enum.map(&process_file/1)
    |> Enum.map(&Task.await/1)
  end

  defp process_file(file) do
    Task.async(fn -> {file, Slave.count(file)} end)
  end
end
