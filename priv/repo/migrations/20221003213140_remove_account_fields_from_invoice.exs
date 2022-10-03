defmodule Invoicer.Repo.Migrations.RemoveAccountFieldsFromInvoice do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      remove :account_no, :string
    end
  end
end
