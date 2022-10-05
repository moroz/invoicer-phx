defmodule InvoicerWeb.InvoiceControllerTest do
  use InvoicerWeb.ConnCase
  import Mock

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
      assert get_resp_header(conn, "content-type") == ["application/pd"]
    end
  end
end
