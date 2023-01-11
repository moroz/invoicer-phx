defmodule InvoicerWeb.Api.InvoiceMutations do
  use InvoicerWeb.GraphQLCase

  alias Invoicer.Clients.Client
  alias Invoicer.Invoices.Invoice

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
        netTotal
        buyer {
          id
        }
        seller {
          id
        }
      }
    }
  }
  """

  @line_items [
    %{
      quantity: 1,
      vat_rate: "NP",
      description: "Services",
      unit_net_price: "2000.00"
    },
    %{
      quantity: 5,
      vat_rate: "TWENTY_THREE",
      description: "Hamburger",
      unit_net_price: 5
    }
  ]

  describe "createInvoice mutation" do
    test "creates an invoice with valid params", ~M{user} do
      buyer = insert(:client, user: user)
      seller = insert(:client, user: user)

      params =
        params_for(:invoice,
          buyer_id: buyer.id,
          seller_id: seller.id,
          line_items: @line_items,
          invoice_type: :invoice_rc
        )
        |> Map.drop([:gross_total, :net_total, :user_id])

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["grossTotal"] == "2030.75"
      assert actual["netTotal"] == "2025.00"
    end

    test "creates an invoice with nested params for clients", ~M{user} do
      assert Repo.count(Client) == 0

      buyer_params = params_for(:client)
      seller_params = params_for(:client)

      params =
        params_for(:invoice, line_items: @line_items, invoice_type: :invoice_rc)
        |> Map.drop([:gross_total, :net_total, :user_id])
        |> Map.put(:buyer, buyer_params)
        |> Map.put(:seller, seller_params)

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => _}} =
        mutate_with_user(@mutation, user, vars)

      assert Repo.count(Client) == 2
    end

    @bank_rate %{"no" => "199/A/NBP/2022", "effective_date" => "2022-10-13", "mid" => 0.6941}

    test "creates an invoice with bank exchange rates", ~M{user} do
      buyer = insert(:client, user: user)
      seller = insert(:client, user: user)

      params =
        params_for(:invoice,
          buyer_id: buyer.id,
          seller_id: seller.id,
          line_items: @line_items,
          invoice_type: :invoice_rc
        )
        |> Map.drop([:gross_total, :net_total, :user_id])
        |> Map.merge(%{
          calculate_exchange_rate: true,
          bank_rate: @bank_rate
        })

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["grossTotal"] == "2030.75"
      assert actual["netTotal"] == "2025.00"
    end

    test "does not create an invoice if the user does not own one of the parties", ~M{user} do
      buyer = insert(:client)
      seller = insert(:client, user: user)

      params =
        params_for(:invoice,
          buyer_id: buyer.id,
          seller_id: seller.id,
          line_items: @line_items,
          invoice_type: :invoice_rc
        )
        |> Map.drop([:gross_total, :net_total, :user_id])

      vars = %{params: params}

      %{"result" => %{"success" => false, "errors" => [error], "data" => nil}} =
        mutate_with_user(@mutation, user, vars)

      assert error["message"] =~ ~r/does not exist/i
    end
  end

  @mutation """
  mutation DeleteInvoice($id: ID!) {
    result: deleteInvoice(id: $id) {
      success
      errors {
        key
        message
      }
    }
  }
  """

  describe "deleteInvoice mutation" do
    test "deletes invoice and clients when called with owned invoice ID", ~M{user} do
      invoice = insert(:invoice, user: user)
      assert Repo.count(Client) == 2
      assert Repo.count(Invoice) == 1

      %{"result" => %{"success" => true, "errors" => []}} =
        mutate_with_user(@mutation, user, %{id: invoice.id})

      refute Repo.reload(invoice)
      refute Repo.reload(invoice.buyer)
      refute Repo.reload(invoice.seller)
    end

    test "does not delete invoice when not owned", ~M{user} do
      invoice = insert(:invoice, user: insert(:user))
      assert Repo.count(Client) == 2
      assert Repo.count(Invoice) == 1

      %{"result" => %{"success" => false, "errors" => [error]}} =
        mutate_with_user(@mutation, user, %{id: invoice.id})

      assert error["message"] =~ ~r"no results"i
    end
  end
end
