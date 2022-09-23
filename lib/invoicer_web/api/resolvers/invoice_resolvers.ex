defmodule InvoicerWeb.Api.InvoiceResolvers do
  import ShorterMaps
  alias Invoicer.Invoices

  def get_invoice(~M{id}, %{context: %{current_user: user}}) do
    {:ok, Invoices.get_user_invoice(user, id)}
  end

  def create_invoice(~M{params}, %{context: %{current_user: user}}) do
    Invoices.create_user_invoice(user, params)
  end
end
