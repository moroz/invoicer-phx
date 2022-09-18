defmodule Invoicer.Repo.Migrations.CreateLineItems do
  use Ecto.Migration

  def change do
    Invoicer.LineItems.LineItem.VatRate.create_type()

    create table(:line_items) do
      add :position, :integer, null: false
      add :description, :string, null: false
      add :unit, :string
      add :quantity, :decimal, default: "1"
      add :unit_net_price, :decimal
      add :vat_rate, :vat_rate, null: false, default: "23%"
      add :invoice_id, references(:invoices, on_delete: :delete_all)

      timestamps()
    end

    create index(:line_items, [:invoice_id])
    create unique_index(:line_items, [:invoice_id, :position])
  end
end
