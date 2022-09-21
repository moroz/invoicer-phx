defmodule Invoicer.Migrator do
  @moduledoc """
  Run Ecto migrations upon application startup.
  Used to automatically trigger database migrations in a CD setup.
  """

  @otp_app :invoicer
  @repo Invoicer.Repo

  require Logger

  use Task, restart: :transient

  def start_link(arg), do: Task.start_link(__MODULE__, :run, [arg])

  def run(_) do
    Logger.info("#{inspect(__MODULE__)} is running database migrations")
    migrations_dir = :code.priv_dir(@otp_app) |> Path.join("repo/migrations")
    Ecto.Migrator.run(@repo, migrations_dir, :up, all: true)
    Logger.info("#{inspect(__MODULE__)} has finished running migrations")
  end
end
