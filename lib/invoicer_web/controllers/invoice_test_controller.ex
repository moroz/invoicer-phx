defmodule InvoicerWeb.InvoiceTestController do
  use InvoicerWeb, :controller

  def index(conn, _params) do
    {:ok, pdf} =
      InvoicerWeb.InvoiceDocument.new()
      |> ElixirLatex.Job.render("invoice.tex", %{locale: [:pl, :de]})

    conn
    |> put_resp_header("content-disposition", "inline")
    |> put_resp_content_type("application/pdf")
    |> resp(200, pdf)
    |> send_resp()
  end
end
