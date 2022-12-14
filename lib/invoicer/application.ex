defmodule Invoicer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @migrator if Mix.env() == :prod, do: [Invoicer.Migrator], else: []

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        Invoicer.Repo,
        # Start the Telemetry supervisor
        InvoicerWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Invoicer.PubSub},
        # Start the Endpoint (http/https)
        InvoicerWeb.Endpoint
        # Start a worker by calling: Invoicer.Worker.start_link(arg)
        # {Invoicer.Worker, arg}
      ] ++ @migrator

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Invoicer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvoicerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
