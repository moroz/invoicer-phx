defmodule Invoicer.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :address_line, :string
      add :city, :string
      add :vat_id, :string
      add :postal_code, :string

      timestamps()
    end
  end
end
