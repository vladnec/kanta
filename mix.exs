defmodule Kanta.MixProject do
  use Mix.Project

  def project do
    [
      app: :kanta,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:gettext, git: "git@github.com:bamorim/gettext.git", branch: "runtime-gettext"},
      {:expo, "~> 0.3.0"},
      {:ecto, "~> 3.9"},
      {:ecto_sql, "~> 3.9"},
      {:phoenix, "~> 1.6"},
      {:jason, "~> 1.0"},
      {:phoenix_live_view, "~> 0.17"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "assets.build": [
        "tailwind default --minify",
        "cmd --cd assets node build.js --deploy"
      ],
      "assets.watch": ["esbuild module --watch"]
    ]
  end
end
