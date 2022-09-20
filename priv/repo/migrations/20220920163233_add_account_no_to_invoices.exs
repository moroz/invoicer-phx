defmodule Invoicer.Repo.Migrations.AddAccountNoToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :account_no, :text
    end
  end
end
