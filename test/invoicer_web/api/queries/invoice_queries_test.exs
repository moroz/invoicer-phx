defmodule InvoicerWeb.Api.InvoiceQueriesTest do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @details """
  fragment LineItemDetails on LineItem {
    id
    description
    unitNetPrice
    unit
    vatRate
    quantity
  }

  fragment ClientDetails on Client {
    id
    name
    vatId
    addressLine
    city
    postalCode
    insertedAt
    updatedAt
  }

  fragment InvoiceDetails on Invoice {
    id
    invoiceNo
    currency
    dateOfSale
    dateOfIssue
    placeOfIssue
    invoiceType
    locale
    buyer {
      ...ClientDetails
    }
    seller {
      ...ClientDetails
      accountNo
      bicCode
      bankName
    }
    lineItems {
      ...LineItemDetails
    }
  }

  """

  @query """
  #{@details}

  query GetInvoice($id: ID!) {
    invoice(id: $id) {
      ...InvoiceDetails
    }
  }
  """

  describe "invoice query" do
    test "returns invoice when called with valid id", ~M{user} do
      invoice = insert(:invoice, user: user)
      %{"invoice" => actual} = query_with_user(@query, user, %{id: invoice.id})
      assert actual["id"] == invoice.id
      assert actual["seller"]["id"] == invoice.seller.id
      assert actual["buyer"]["id"] == invoice.buyer.id
    end

    test "returns null when called with other user's invoice id", ~M{user} do
      invoice = insert(:invoice)
      %{"invoice" => nil} = query_with_user(@query, user, %{id: invoice.id})
    end

    test "return null when called with a non-existent id", ~M{user} do
      vars = %{id: Ecto.UUID.generate()}
      %{"invoice" => nil} = query_with_user(@query, user, vars)
    end
  end
end
