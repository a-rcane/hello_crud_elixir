defmodule HelloCrudElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_crud_elixir,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      # <-- Add this line to specify application callback module
      mod: {HelloCrudElixir.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # <-- Add Cowboy web server plug
      {:plug_cowboy, "~> 2.6"},
      # <-- Add JSON parser
      {:jason, "~> 1.4"}
    ]
  end
end
