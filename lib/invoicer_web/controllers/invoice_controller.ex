defmodule InvoicerWeb.InvoiceController do
  use InvoicerWeb, :controller
  alias InvoicerWeb.InvoiceDocument
  alias Invoicer.Invoices

  import ShorterMaps

  def show(conn, ~m{id}) do
    invoice = Invoices.get_user_invoice(conn.assigns.current_user, id)

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
