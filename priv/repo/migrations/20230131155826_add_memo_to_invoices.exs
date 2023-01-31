defmodule Invoicer.Repo.Migrations.AddMemoToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :memo, :text
    end
  end
end
