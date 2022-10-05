defmodule InvoicerWeb.InvoiceControllerTest do
  use InvoicerWeb.ConnCase
  import Mock
  alias InvoicerWeb.InvoiceDocument

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> Plug.Test.init_test_session(%{user_id: user.id})

    invoice = insert(:invoice, user: user)
    [conn: conn, user: user, invoice: invoice]
  end

  describe "GET show" do
    test "correctly renders file to PDF", ~M{conn, invoice} do
      conn = get(conn, Routes.invoice_path(conn, :show, invoice))
      [content_type] = get_resp_header(conn, "content-type")
      assert content_type =~ "application/pdf"
      ["inline"] = get_resp_header(conn, "content-disposition")
      "%PDF" <> _ = conn.resp_body
    end

    test "with download=true passed in query string, sets content-disposition: attachment",
         ~M{conn, invoice} do
      with_mock(InvoiceDocument, [:passthrough], generate: fn _ -> {:ok, "%PDFtest"} end) do
        conn = get(conn, Routes.invoice_path(conn, :show, invoice, download: true))
        [content_type] = get_resp_header(conn, "content-type")
        assert content_type =~ "application/pdf"
        ["attachment; filename=" <> _] = get_resp_header(conn, "content-disposition")
      end
    end
  end
end
