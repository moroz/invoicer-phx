defmodule InvoicerWeb.Plug.FetchUser do
  @behaviour Plug

  import Plug.Conn
  alias Invoicer.Users

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts \\ nil) do
    user = get_user_from_conn(conn)

    conn
    |> assign(:current_user, user)
    |> Absinthe.Plug.put_options(context: %{current_user: user})
  end

  defp get_user_from_conn(conn) do
    case get_session(conn, :user_id) do
      id when is_binary(id) ->
        Users.get_user(id)

      _ ->
        nil
    end
  end
end
