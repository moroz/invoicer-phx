defmodule Invoicer.Repo.Migrations.AddNetTotalToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :net_total, :decimal, null: false, default: 0
    end
  end
end
