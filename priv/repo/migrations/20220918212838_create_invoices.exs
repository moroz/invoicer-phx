defmodule Invoicer.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :invoice_no, :string, null: false
      add :date_of_issue, :date, null: false, default: fragment("current_date")
      add :date_of_sale, :date, null: false, default: fragment("current_date")
      add :place_of_issue, :string
      add :gross_total, :decimal, null: false, default: "0.0"
      add :seller_id, references(:companies, on_delete: :restrict), null: false
      add :buyer_id, references(:companies, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:invoices, [:seller_id])
    create index(:invoices, [:buyer_id])
  end
end
