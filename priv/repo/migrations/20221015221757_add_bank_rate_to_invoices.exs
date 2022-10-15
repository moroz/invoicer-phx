defmodule Invoicer.Repo.Migrations.AddBankRateToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :bank_rate, :jsonb
      add :calculate_exchange_rate, :boolean, null: false, default: true
    end
  end
end
