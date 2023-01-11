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

  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  def create_user_invoice(%User{} = user, attrs) do
    %Invoice{user_id: user.id}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def filter_and_paginate_invoices(%User{} = user, params) do
    user
    |> Ecto.assoc(:invoices)
    |> preload(:buyer)
    |> order_by(desc: :invoice_no, desc: :inserted_at)
    |> filter_by_params(params)
    |> Repo.paginate(params)
  end

  defp filter_by_params(query, params) do
    Enum.reduce(params, query, &do_filter_by_params/2)
  end

  defp do_filter_by_params({:q, term}, query) do
    ilike_clause = "%#{term}%"
    where(query, [i], ilike(i.invoice, ^ilike_clause))
  end

  defp do_filter_by_params(_, query), do: query

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
    |> order_by(:inserted_at)
    |> last
    |> Repo.one()
    |> preload_assocs()
  end
end
