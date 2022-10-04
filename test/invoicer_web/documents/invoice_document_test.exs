defmodule InvoicerWeb.InvoiceDocumentTest do
  use Invoicer.DataCase, async: true
  alias InvoicerWeb.InvoiceDocument

  test "renders an invoice to tex when called with valid invoice" do
    invoice = build(:invoice) |> with_line_items() |> insert()
    source = InvoiceDocument.render_source(invoice)
    assert is_binary(source)
  end
end
