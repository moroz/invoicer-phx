defmodule Invoicer.Invoices.Invoice do
  use Invoicer.Schema
  import Ecto.Changeset
  alias Invoicer.Companies.Company
  alias Invoicer.LineItems.LineItem
  alias Invoicer.Invoices.Calculator

  schema "invoices" do
    field :date_of_issue, :date
    field :date_of_sale, :date
    field :gross_total, :decimal, default: Decimal.new(0)
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
    |> cast_assoc(:line_items, with: &LineItem.changeset/2)
    |> set_line_item_positions()
    |> set_totals()
  end

  defp set_line_item_positions(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :line_items) do
      nil ->
        changeset

      items ->
        items =
          items
          |> Enum.with_index()
          |> Enum.map(fn {item, index} ->
            case get_field(item, :position) do
              nil ->
                put_change(item, :position, index + 1)

              _ ->
                item
            end
          end)

        put_change(changeset, :line_items, items)
    end
  end

  defp set_line_item_positions(changeset), do: changeset

  defp set_totals(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :line_items) do
      nil ->
        changeset

      items ->
        # net_total = Calculator.total_net_price(items)
        gross_total = Calculator.total_gross_price(items)
        put_change(changeset, :gross_total, gross_total)
    end
  end

  defp set_totals(changeset), do: changeset
end
