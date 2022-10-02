defmodule InvoicerWeb.Plug.RestrictAccess do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      nil ->
        deny_access(conn)

      _ ->
        conn
    end
  end

  defp deny_access(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
