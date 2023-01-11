defmodule Invoicer.Invoices.Invoice do
  use Invoicer.Schema
  import Ecto.Changeset
  alias Invoicer.Clients
  alias Invoicer.Clients.Client
  alias Invoicer.LineItems.LineItem
  alias Invoicer.Invoices.Calculator
  alias Invoicer.Invoices.BankRate

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
    field :calculate_exchange_rate, :boolean, default: false
    embeds_one :bank_rate, BankRate
    belongs_to :seller, Client, on_replace: :nilify
    belongs_to :buyer, Client, on_replace: :nilify
    belongs_to :user, Invoicer.Users.User
    has_many :line_items, LineItem, on_replace: :delete

    field :buyer_template_id, :binary_id, virtual: true
    field :seller_template_id, :binary_id, virtual: true

    timestamps()
  end

  @required ~w(invoice_no date_of_issue date_of_sale place_of_issue
    currency user_id invoice_type payment_method)a
  @cast @required ++ ~w[locale buyer_id seller_id calculate_exchange_rate
                        seller_template_id buyer_template_id]a

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> validate_format(:currency, ~r/^[A-Z]{3}$/, message: "must be 3-letter code")
    |> cast_assoc(:line_items, with: &LineItem.changeset/2)
    |> cast_and_validate_exchange_rate()
    |> validate_user_matches(:buyer_template_id)
    |> validate_user_matches(:seller_template_id)
    |> copy_clients_from_templates()
    |> cast_clients_from_nested_params()
    |> set_line_item_positions()
    |> set_totals()
  end

  defp copy_clients_from_templates(changeset) do
    changeset
    |> maybe_copy_client_from_template(:buyer)
    |> maybe_copy_client_from_template(:seller)
  end

  defp maybe_copy_client_from_template(changeset, assoc_name) do
    case get_change(changeset, :"#{assoc_name}_template_id") do
      nil ->
        changeset

      template_id ->
        user_id = get_field(changeset, :user_id)
        copy_client_from_template(changeset, assoc_name, user_id, template_id)
    end
  end

  defp copy_client_from_template(changeset, assoc_name, user_id, template_id) do
    case Clients.get_user_client_template(user_id, template_id) do
      nil ->
        add_error(changeset, :"#{assoc_name}_template_id", "client does not exist")

      %Client{} = template ->
        client = Client.from_template(template)
        put_assoc(changeset, assoc_name, client)
    end
  end

  defp cast_clients_from_nested_params(changeset) do
    changeset
    |> maybe_cast_client_from_nested_param(:buyer)
    |> maybe_cast_client_from_nested_param(:seller)
  end

  defp maybe_cast_client_from_nested_param(changeset, assoc_name) do
    case get_change(changeset, assoc_name) do
      nil ->
        changeset
        |> cast_assoc(assoc_name, with: &Client.changeset/2)
        |> set_user_id_on_client_params(assoc_name)

      _ ->
        changeset
    end
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
          |> Enum.reject(fn changeset -> changeset.action == :replace end)
          |> Enum.with_index()
          |> Enum.map(fn {item, index} ->
            case get_field(item, :position) do
              nil ->
                put_change(item, :position, index + 1)

              _ ->
                item
            end
          end)

        put_assoc(changeset, :line_items, items)
    end
  end

  defp set_line_item_positions(changeset), do: changeset

  defp set_totals(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :line_items) do
      nil ->
        changeset

      items ->
        items = Enum.reject(items, fn changeset -> changeset.action == :replace end)
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

  defp cast_and_validate_exchange_rate(changeset) do
    case get_field(changeset, :calculate_exchange_rate) do
      true ->
        changeset
        |> cast_embed(:bank_rate, with: &BankRate.changeset/2, required: true)

      _ ->
        changeset
    end
  end
end
