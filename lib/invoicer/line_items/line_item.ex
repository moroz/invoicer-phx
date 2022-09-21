defmodule Invoicer.LineItems.LineItem do
  use Invoicer.Schema
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
end
