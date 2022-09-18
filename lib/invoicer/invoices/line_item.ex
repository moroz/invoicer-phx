defmodule Invoicer.Invoices.LineItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Invoicer.Invoices.LineItem.VatRate

  schema "line_items" do
    field :description, :string
    field :position, :integer
    field :quantity, :decimal
    field :unit, :string
    field :unit_net_price, :decimal
    field :vat_rate, VatRate
    belongs_to :invoice, Invoicer.Invoices.Invoice

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:description, :unit, :quantity, :unit_net_price, :vat_rate])
    |> validate_required([:description, :unit, :quantity, :unit_net_price, :vat_rate])
  end

  def total_net_price(%__MODULE__{} = item) do
    Decimal.mult(item.quantity, item.unit_net_price)
  end

  def vat_amount(%__MODULE__{} = item) do
    vat_rate = VatRate.numeric_value(item.vat_rate)

    item
    |> total_net_price()
    |> Decimal.mult(vat_rate)
  end

  def total_gross_price(%__MODULE__{} = item) do
    Decimal.add(total_net_price(item), vat_amount(item))
  end
end
