defmodule Invoicer.Invoices do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.Invoices.Invoice
  alias Invoicer.LineItems.LineItem
  alias Invoicer.Users.User

  def get_user_invoice(%User{} = user, invoice_id) do
    user
    |> Ecto.assoc(:invoices)
    |> get_invoice_with_assocs(invoice_id)
  end

  def create_invoice(attrs) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def preload_assocs(invoice) do
    line_items_query = order_by(LineItem, :position)
    Repo.preload(invoice, [:buyer, :seller, line_items: line_items_query])
  end

  def get_invoice_with_assocs(scope \\ Invoice, id) do
    scope
    |> Repo.get!(id)
    |> preload_assocs()
  end

  def get_last do
    Invoice
    |> last
    |> Repo.one()
    |> preload_assocs()
  end
end
