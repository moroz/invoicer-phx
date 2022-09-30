defmodule Invoicer.Repo.Migrations.RenameCompaniesToClients do
  use Ecto.Migration

  def change do
    rename table(:companies), to: table(:clients)
  end
end
