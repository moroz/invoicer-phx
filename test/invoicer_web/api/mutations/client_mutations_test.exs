defmodule InvoicerWeb.Api.ClientMutationsTest do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @mutation """
  mutation CreateClient($params: ClientParams!) {
    result: createClient(params: $params) {
      success
      errors {
        key
        message
        validation
      }
      data {
        id
        vatId
        name
        addressLine
        templateType
      }
    }
  }
  """

  describe "createClient mutation" do
    test "creates client with valid params", ~M{user} do
      params = params_for(:client, template_type: :buyer) |> Map.drop([:user])

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["name"] == params.name
      assert actual["vatId"] == params.vat_id
      assert actual["addressLine"] == params.address_line
      assert actual["templateType"] == "BUYER"
    end
  end

  @mutation """
  mutation UpdateClient($id: ID!, $params: ClientParams!) {
    result: updateClient(id: $id, params: $params) {
      success
      errors {
        key
        message
      }
      data {
        id
        vatId
        name
        addressLine
        city
      }
    }
  }
  """

  describe "updateClient mutation" do
    test "updates client with valid params", ~M{user} do
      client = insert(:client, user: user)

      params = %{
        vat_id: "updated vat_id",
        city: "updated city",
        postal_code: "updated code",
        address_line: "updated address",
        name: "updated name"
      }

      vars = %{id: client.id, params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => _updated}} =
        mutate_with_user(@mutation, user, vars)

      client = Repo.reload!(client)

      for {key, value} <- params do
        assert Map.get(client, key) == value
      end
    end
  end
end
