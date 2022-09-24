defmodule InvoicerWeb.GraphQLCase do
  @moduledoc """
  ExUnit case template for tests of the GraphQL APIs.
  Provides helper functions for querying the API and normalizing
  GraphQL variables.
  """

  defmacro __using__(opts \\ []) do
    schema = Keyword.get(opts, :schema, InvoicerWeb.Api.Schema)
    api_path = Keyword.get(opts, :api_path, "/api")

    quote do
      @__schema__ unquote(schema)
      @__api_path__ unquote(api_path)
      @endpoint InvoicerWeb.Endpoint

      alias Ecto.Adapters.SQL.Sandbox
      alias Invoicer.Repo

      use ExUnit.Case

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Invoicer.DataCase
      import Invoicer.Factory
      import InvoicerWeb.GraphQLCase
      import InvoicerWeb.ConnCase
      import Phoenix.ConnTest
      import ShorterMaps

      setup tags do
        :ok = Sandbox.checkout(Invoicer.Repo)

        Absinthe.Test.prime(@__schema__)

        unless tags[:async] do
          Sandbox.mode(Invoicer.Repo, {:shared, self()})
        end

        [conn: Phoenix.ConnTest.build_conn()]
      end
    end
  end

  @endpoint InvoicerWeb.Endpoint
  import Phoenix.ConnTest

  def query(document, variables \\ %{}) do
    opts = [variables: normalize_variables(variables)]
    Absinthe.run!(document, InvoicerWeb.Api.Schema, opts)
  end

  def query(document, user, variables) do
    query_with_user(document, user, variables)
  end

  def query_with_user(document, user, variables \\ %{}) do
    opts = [variables: normalize_variables(variables), context: %{current_user: user}]

    case Absinthe.run!(document, InvoicerWeb.Api.Schema, opts) do
      %{data: data} when not is_nil(data) ->
        data

      error ->
        {:error, error}
    end
  end

  @doc """
  Sends the given `query` to the API endpoint over the given `conn`.
  """
  def query_over_router(conn, query, variables \\ %{}) do
    variables = normalize_variables(variables)

    conn
    |> Plug.Conn.put_req_header("content-type", "application/json")
    |> post("/api", Jason.encode!(%{query: query, variables: variables}))
  end

  @doc """
  Same as `query_over_router/3`, but returns parsed JSON response rather
  than a `Plug.Conn` struct.
  """
  def query_over_router!(conn, query, variables \\ %{}) do
    conn = query_over_router(conn, query, variables)
    json_response(conn, 200)
  end

  def mutate(document, variables), do: query(document, variables)
  def mutate(document, user, variables), do: query_with_user(document, user, variables)

  def mutate_with_user(document, user, variables) do
    query_with_user(document, user, variables)
  end

  def normalize_variables([]), do: []

  def normalize_variables([id | _tail] = list) when is_binary(id) or is_integer(id), do: list

  def normalize_variables([enum | _tail] = list) when is_atom(enum),
    do: Enum.map(list, &normalize_variables/1)

  def normalize_variables([head | _tail] = list) when is_map(head) do
    Enum.map(list, &normalize_variables/1)
  end

  def normalize_variables(%Plug.Upload{} = upload), do: upload

  def normalize_variables(%module{} = datetime) when module in [Date, DateTime, NaiveDateTime] do
    module.to_iso8601(datetime)
  end

  def normalize_variables(variables) when is_map(variables) or is_list(variables) do
    Map.new(variables, fn {key, val} ->
      {normalize_variable_key(key), normalize_variables(val)}
    end)
  end

  def normalize_variables(atom) when is_atom(atom) and atom not in [true, false, nil] do
    atom |> to_string() |> String.upcase()
  end

  def normalize_variables(other), do: other

  defp normalize_variable_key(key) do
    key
    |> to_string()
    |> Absinthe.Adapter.LanguageConventions.to_external_name(:key)
  end

  def conn_for_user(%Invoicer.Users.User{} = user) do
    init_test_session(build_conn(), %{user_id: user.id})
  end
end
