defmodule InvoicerWeb.InvoiceTestController do
  use InvoicerWeb, :controller
  alias InvoicerWeb.InvoiceDocument

  alias Invoicer.Invoices

  def index(conn, _params) do
    invoice = Invoices.get_last()
    {:ok, pdf} = InvoiceDocument.generate(invoice)

    conn
    |> put_resp_header("content-disposition", "inline")
    |> put_resp_content_type("application/pdf")
    |> resp(200, pdf)
    |> send_resp()
  end
end
