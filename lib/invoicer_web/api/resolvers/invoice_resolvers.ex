defmodule InvoicerWeb.Api.InvoiceResolvers do
  import ShorterMaps
  alias Invoicer.Invoices

  def get_invoice(~M{id}, _) do
    {:ok, Invoices.get_invoice_with_assocs(id)}
  end
end
