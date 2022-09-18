defmodule Invoicer.Invoices.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  import EctoEnum

  defenum(VatRate, :vat_rate, ["np.", "zw.", "o.o.", "0%", "5%", "7%", "8%", "23%"])

  schema "line_items" do
    field :description, :string
    field :quantity, :decimal
    field :unit, :string
    field :unit_net_price, :decimal
    field :vat_rate, :integer
    field :invoice_id, :id

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:description, :unit, :quantity, :unit_net_price, :vat_rate])
    |> validate_required([:description, :unit, :quantity, :unit_net_price, :vat_rate])
  end
end
