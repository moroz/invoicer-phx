defmodule Invoicer.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  alias Invoicer.Companies.Company

  schema "invoices" do
    field :date_of_issue, :date
    field :date_of_sale, :date
    field :gross_total, :decimal
    field :invoice_no, :string
    field :place_of_issue, :string
    belongs_to :seller, Company
    belongs_to :buyer, Company

    timestamps()
  end

  @required ~w(invoice_no date_of_issue date_of_sale place_of_issue gross_total buyer_id seller_id)a

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
