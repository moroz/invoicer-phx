defmodule InvoicerWeb.Api.InvoiceResolvers do
  import ShorterMaps
  alias Invoicer.Invoices

  def get_invoice(~M{id}, %{context: %{current_user: user}}) do
    {:ok, Invoices.get_user_invoice(user, id)}
  end
end
