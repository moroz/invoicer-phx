defmodule Invoicer.Repo.Migrations.AssociateInvoicesWithUsers do
  use Ecto.Migration

  def change do
    execute "truncate invoices cascade"

    alter table(:invoices) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end

  def down do
    alter table(:invoices) do
      remove :user_id
    end
  end
end
