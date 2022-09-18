defmodule InvoicerWeb.InvoiceTestController do
  use InvoicerWeb, :controller
  alias InvoicerWeb.InvoiceDocument

  def index(conn, _params) do
    {:ok, pdf} = InvoiceDocument.generate([:de, :pl])

    conn
    |> put_resp_header("content-disposition", "inline")
    |> put_resp_content_type("application/pdf")
    |> resp(200, pdf)
    |> send_resp()
  end
end
