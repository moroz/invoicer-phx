defmodule InvoicerWeb.Api.ClientMutationsTest do
  use InvoicerWeb.GraphQLCase

  setup do
    [user: insert(:user)]
  end

  @mutation """
  mutation CreateClient($params: CompanyParams!) {
    result: createClient(params: $params) {
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
      }
    }
  }
  """

  describe "createClient mutation" do
    test "creates company with valid params", ~M{user} do
      params = params_for(:company) |> Map.drop([:user])

      vars = %{params: params}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["name"] == params.name
      assert actual["vatId"] == params.vat_id
      assert actual["addressLine"] == params.address_line
    end
  end
end
