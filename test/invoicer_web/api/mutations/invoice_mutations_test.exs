defmodule InvoicerWeb.Api.InvoiceMutations do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @mutation """
  mutation CreateInvoice($params: InvoiceParams!) {
    result: createInvoice(params: $params) {
      success
      errors {
        key
        message
      }
      data {
        id
        invoiceNo
        grossTotal
      }
    }
  }
  """

  describe "createInvoice mutation" do
    test "creates an invoice with valid params", ~M{user} do
      buyer = insert(:company)
      seller = insert(:company)

      line_items = [
        %{quantity: 1, vat_rate: "NP", description: "Services", unit_net_price: "2000.00"},
        %{quantity: 5, vat_rate: "TWENTY_THREE", description: "Hamburger", unit_net_price: 5}
      ]

      params =
        params_for(:invoice, buyer_id: buyer.id, seller_id: seller.id, line_items: line_items)
        |> Map.delete(:gross_total)

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["grossTotal"] == "2030.75"
    end
  end
end
