defmodule Invoicer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "create extension if not exists citext"

    create table(:users) do
      add :email, :citext, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
