defmodule Invoicer.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :date_of_issue, :date
    field :date_of_sale, :date
    field :gross_total, :decimal
    field :invoice_no, :string
    field :place_of_issue, :string
    field :seller, :id
    field :buyer, :id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:invoice_no, :date_of_issue, :date_of_sale, :place_of_issue, :gross_total])
    |> validate_required([:invoice_no, :date_of_issue, :date_of_sale, :place_of_issue, :gross_total])
  end
end
