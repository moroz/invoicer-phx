defmodule InvoicerWeb.Api.SignIn do
  @behaviour Absinthe.Middleware
  import ShorterMaps

  alias Invoicer.Users
  alias Invoicer.Users.User

  def call(%Absinthe.Resolution{state: :resolved} = res, _opts), do: res

  def call(%Absinthe.Resolution{} = res, _opts) do
    ~M{email, password} = res.arguments

    case Users.authenticate_user_by_email_password(email, password) do
      {:ok, %User{} = user} ->
        sign_user_in(res, user)

      _ ->
        deny_access(res)
    end
  end

  @doc """
  Grants access to a `Invoicer.Users.User` and returns a success response.
  """
  def sign_user_in(%Absinthe.Resolution{} = res, %User{} = user) do
    session = [user_id: user.id]
    context = Map.put(res.context, :set_session, session)
    value = %{success: true, data: user, errors: []}
    %{res | context: context, value: value, state: :resolved}
  end

  @doc """
  Rejects the mutation with an error status response and logs an
  invalid login attempt.
  """
  def deny_access(%Absinthe.Resolution{} = res) do
    value = %{success: false}
    %{res | value: value, state: :resolved}
  end
end
