defmodule Invoicer.MixProject do
  use Mix.Project

  def project do
    [
      app: :invoicer,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Invoicer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:elixir_latex, github: "moroz/elixir_latex"},
      {:ecto_enum, "~> 1.4"},
      {:timex, "~> 3.7"},
      {:hackney, "~> 1.18"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:ex_machina, "~> 2.7"},
      {:shorter_maps, "~> 2.2"},
      {:cors_plug, "~> 3.0"},
      {:graphql_tools, github: "moroz/graphql_tools"},
      # {:graphql_tools, path: "../graphql_tools"},
      {:scrivener_ecto, "~> 2.7"},
      {:mock, "~> 0.3.7"},
      {:uniq, "~> 0.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": "run priv/repo/seeds.exs",
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      genlocales: [
        "gettext.extract",
        "gettext.merge priv/gettext --locale de",
        "gettext.merge priv/gettext --locale pl"
      ]
    ]
  end
end
