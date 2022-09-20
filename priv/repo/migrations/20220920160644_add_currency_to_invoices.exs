defmodule Invoicer.Repo.Migrations.AddCurrencyToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :currency, :string, null: false
    end
  end
end
