defmodule InvoicerWeb.Api.InvoiceMutations do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @mutation """
  mutation CreateInvoice($params: InvoiceParams!) {
    createInvoice(params: $params) {
      success
      errors {
        key
        value
      }
      data {
        id
        invoiceNo
      }
    }
  }
  """

  describe "createInvoice mutation" do
    test "creates an invoice with valid params", ~M{user} do
      params = params_for(:invoice)
    end
  end
end
