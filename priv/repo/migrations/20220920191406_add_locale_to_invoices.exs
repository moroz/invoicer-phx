defmodule Invoicer.Repo.Migrations.AddLocaleToInvoices do
  use Ecto.Migration

  def change do
    Invoicer.Invoices.Locale.create_type()

    alter table(:invoices) do
      add :locale, {:array, :locale}, null: false, default: fragment("'{pl}'")
    end
  end
end
