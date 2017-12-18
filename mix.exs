defmodule HtmlToPdf.Mixfile do
  use Mix.Project

  def project do
    [
      app: :htmltopdf,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      compilers: [:elixir_make] ++ Mix.compilers
    ]
  end

  def application do
    [
      extra_applications: [:logger, :erlexec, :exexec],
      mod: {HtmlToPdf.Application, []}
    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:exexec, "~> 0.1.0"},
      {:poolboy, "~> 1.5"},
      {:socket, "~> 0.3.12"},
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
    ]
  end
end
