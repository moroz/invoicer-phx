defmodule Invoicer.Repo.Migrations.AddBankDataToClients do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :account_no, :string
      add :bic_code, :string
      add :bank_name, :string
    end
  end
end
