defmodule InvoicerWeb.InvoiceTestController do
  use InvoicerWeb, :controller
  alias InvoicerWeb.InvoiceDocument

  alias Invoicer.Invoices

  def index(conn, _params) do
    invoice = Invoices.get_last()

    case InvoiceDocument.generate(invoice) do
      {:ok, pdf} ->
        conn
        |> put_resp_header("content-disposition", "inline")
        |> put_resp_content_type("application/pdf")
        |> resp(200, pdf)
        |> send_resp()

      {:error, error} ->
        conn
        |> put_resp_content_type("text/plain")
        |> resp(200, error)
        |> send_resp()
    end
  end
end
