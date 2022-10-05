defmodule InvoicerWeb.Api.UserResolvers do
  alias Invoicer.Users

  def current_user(_, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def sign_up(%{params: params}, _) do
    Users.create_user(params)
  end
end
