defmodule InvoicerWeb.Api.Middleware.RestrictAccess do
  @behaviour Absinthe.Middleware

  alias Invoicer.Users.User

  @moduledoc """
  Absinthe middleware to deny access to unauthenticated users.
  """

  @impl true
  def call(%{context: %{current_user: %User{}}} = res, _opts) do
    res
  end

  def call(%Absinthe.Resolution{} = res, _opts) do
    %{res | errors: ["You need to authenticate to perform this action."], state: :resolved}
  end
end
