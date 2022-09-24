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

      params =
        params_for(:invoice, buyer_id: buyer.id, seller_id: seller.id) |> Map.delete(:gross_total)

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["grossTotal"]
    end
  end
end
