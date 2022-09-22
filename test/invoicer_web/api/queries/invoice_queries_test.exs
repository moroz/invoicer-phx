defmodule InvoicerWeb.Api.InvoiceQueriesTest do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @query """
  query GetInvoice($id: ID!) {
    invoice(id: $id) {
      id
      invoiceNo
    }
  }
  """

  describe "invoice query" do
    test "returns invoice when called with valid id", ~M{user} do
      invoice = insert(:invoice)
      %{"invoice" => actual} = query_with_user(@query, user, %{id: invoice.id})
      assert actual["id"] == invoice.id
    end
  end
end
