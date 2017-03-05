defmodule Ewc.Mixfile do
  use Mix.Project

  def project do
    [app: :ewc,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  def escript do
    [main_module: Ewc.CLI]
  end

  defp deps do
    []
  end
end
