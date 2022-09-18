defmodule Invoicer.Invoices.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "line_items" do
    field :description, :string
    field :position, :integer
    field :quantity, :decimal
    field :unit, :string
    field :unit_net_price, :decimal
    field :vat_rate, Invoicer.Invoices.LineItem.VatRate
    belongs_to :invoice, Invoicer.Invoices.Invoice

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:description, :unit, :quantity, :unit_net_price, :vat_rate])
    |> validate_required([:description, :unit, :quantity, :unit_net_price, :vat_rate])
  end
end
