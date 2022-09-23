defmodule Invoicer.Invoices.Invoice do
  use Invoicer.Schema
  import Ecto.Changeset
  alias Invoicer.Companies.Company
  alias Invoicer.LineItems.LineItem

  schema "invoices" do
    field :date_of_issue, :date
    field :date_of_sale, :date
    field :gross_total, :decimal, default: 0
    field :invoice_no, :string
    field :place_of_issue, :string
    field :currency, :string
    field :account_no, :string
    field :locale, {:array, Invoicer.Invoices.Locale}
    belongs_to :seller, Company
    belongs_to :buyer, Company
    belongs_to :user, Invoicer.Users.User
    has_many :line_items, LineItem, on_replace: :delete

    timestamps()
  end

  @required ~w(invoice_no date_of_issue date_of_sale place_of_issue gross_total buyer_id seller_id currency)a
  @cast @required ++ [:account_no, :locale]

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> validate_format(:currency, ~r/^[A-Z]{3}$/, message: "must be 3-letter code")
  end
end
