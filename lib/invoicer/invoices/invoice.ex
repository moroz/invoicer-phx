defmodule Invoicer.Invoices.Invoice do
  use Invoicer.Schema
  import Ecto.Changeset
  alias Invoicer.Clients
  alias Invoicer.Clients.Client
  alias Invoicer.LineItems.LineItem
  alias Invoicer.Invoices.Calculator

  schema "invoices" do
    field :date_of_issue, :date
    field :date_of_sale, :date
    field :gross_total, :decimal, default: Decimal.new(0)
    field :net_total, :decimal, default: Decimal.new(0)
    field :invoice_no, :string
    field :place_of_issue, :string
    field :currency, :string
    field :locale, {:array, Invoicer.Invoices.Locale}
    field :payment_method, Invoicer.Invoices.PaymentMethod
    field :invoice_type, Invoicer.Invoices.InvoiceType
    belongs_to :seller, Client
    belongs_to :buyer, Client
    belongs_to :user, Invoicer.Users.User
    has_many :line_items, LineItem, on_replace: :delete

    timestamps()
  end

  @required ~w(invoice_no date_of_issue date_of_sale place_of_issue gross_total
    currency user_id invoice_type payment_method)a
  @cast @required ++ [:locale, :buyer_id, :seller_id]

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> validate_format(:currency, ~r/^[A-Z]{3}$/, message: "must be 3-letter code")
    |> cast_assoc(:line_items, with: &LineItem.changeset/2)
    |> cast_assoc(:buyer, with: &Client.changeset/2)
    |> cast_assoc(:seller, with: &Client.changeset/2)
    |> set_user_id_on_client_params(:buyer)
    |> set_user_id_on_client_params(:seller)
    |> validate_user_matches(:buyer_id)
    |> validate_user_matches(:seller_id)
    |> set_line_item_positions()
    |> set_totals()
  end

  defp set_user_id_on_client_params(%Ecto.Changeset{valid?: true} = changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      %Ecto.Changeset{} = client_changeset ->
        user_id = get_field(changeset, :user_id)
        client_changeset = put_change(client_changeset, :user_id, user_id)
        put_change(changeset, field, client_changeset)
    end
  end

  defp set_user_id_on_client_params(changeset, _field), do: changeset

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
        net_total = Calculator.total_net_price(items)
        gross_total = Calculator.total_gross_price(items)

        changeset
        |> put_change(:gross_total, gross_total)
        |> put_change(:net_total, net_total)
    end
  end

  defp set_totals(changeset), do: changeset

  defp validate_user_matches(%Ecto.Changeset{valid?: true} = changeset, field) do
    user_id = get_field(changeset, :user_id)

    case get_change(changeset, field) do
      nil ->
        changeset

      id ->
        case Clients.get_user_client(user_id, id) do
          nil ->
            add_error(changeset, field, "client does not exist")

          %Client{} ->
            changeset
        end
    end
  end

  defp validate_user_matches(changeset, _field), do: changeset
end
