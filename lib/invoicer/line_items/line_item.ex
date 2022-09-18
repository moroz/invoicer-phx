defmodule Invoicer.LineItems.LineItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Invoicer.LineItems.LineItem.VatRate

  schema "line_items" do
    field :description, :string
    field :position, :integer
    field :quantity, :decimal, default: 1
    field :unit, :string
    field :unit_net_price, :decimal
    field :vat_rate, VatRate
    belongs_to :invoice, Invoicer.Invoices.Invoice

    timestamps()
  end

  @required ~w(description position quantity unit_net_price vat_rate invoice_id)a
  @cast @required ++ [:unit]

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, @cast)
    |> validate_required(@required)
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
