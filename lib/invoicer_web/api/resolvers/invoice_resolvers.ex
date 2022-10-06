defmodule InvoicerWeb.Api.InvoiceResolvers do
  import ShorterMaps
  alias Invoicer.Invoices

  def get_invoice(~M{id}, %{context: %{current_user: user}}) do
    {:ok, Invoices.get_user_invoice(user, id)}
  end

  def update_invoice(~M{id, params}, %{context: %{current_user: user}}) do
    invoice = Invoices.get_user_invoice(user, id)
    Invoices.update_invoice(invoice, params)
  end

  def create_invoice(~M{params}, %{context: %{current_user: user}}) do
    Invoices.create_user_invoice(user, params)
  end

  def filter_and_paginate_invoices(~M{params}, %{context: %{current_user: user}}) do
    {:ok, Invoices.filter_and_paginate_invoices(user, params)}
  end
end
