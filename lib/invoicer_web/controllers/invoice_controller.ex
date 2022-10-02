defmodule InvoicerWeb.InvoiceController do
  use InvoicerWeb, :controller
  alias InvoicerWeb.InvoiceDocument
  alias Invoicer.Invoices
  alias Invoicer.FilenameHelpers

  import ShorterMaps

  def show(conn, ~m{id} = params) do
    download = Map.get(params, "download", "false")
    invoice = Invoices.get_user_invoice(conn.assigns.current_user, id)

    case InvoiceDocument.generate(invoice) do
      {:ok, pdf} ->
        conn
        |> put_content_disposition(invoice, download)
        |> put_resp_content_type("application/pdf")
        |> resp(200, pdf)
        |> send_resp()

      {:error, error} ->
        conn
        |> put_resp_content_type("text/plain")
        |> resp(500, error)
        |> send_resp()
    end
  end

  defp put_content_disposition(conn, invoice, "true") do
    filename = FilenameHelpers.sanitize_filename("invoice-#{invoice.invoice_no}.pdf")
    put_resp_header(conn, "content-disposition", "attachment; filename=\"#{filename}\"")
  end

  defp put_content_disposition(conn, _invoice, _) do
    put_resp_header(conn, "content-disposition", "inline")
  end
end
