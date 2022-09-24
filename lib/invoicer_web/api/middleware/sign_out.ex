defmodule InvoicerWeb.Api.Middleware.SignOut do
  @moduledoc """
  Absinthe middleware module handling sign out workflows.
  It basically just drops the whole session.
  """

  @behaviour Absinthe.Middleware

  @impl true
  def call(%Absinthe.Resolution{state: :resolved} = res, _opts), do: res

  def call(%Absinthe.Resolution{} = res, _opts) do
    context = Map.put(res.context, :drop_session, true)
    %{res | context: context, value: true, state: :resolved}
  end
end
