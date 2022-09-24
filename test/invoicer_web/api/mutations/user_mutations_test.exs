defmodule InvoicerWeb.Api.UserMutationsTest do
  use InvoicerWeb.GraphQLCase
  import Plug.Conn

  @password "foobar2000"
  @password_hash Bcrypt.hash_pwd_salt(@password)

  setup do
    conn = build_conn() |> init_test_session(%{})
    [user: insert(:user, password_hash: @password_hash), conn: conn]
  end

  @mutation """
  mutation SignIn($email: String!, $password: String!) {
    signIn(email: $email, password: $password) {
      success
      data {
        id
      }
    }
  }
  """

  describe "signIn mutation" do
    test "signs user in with valid email and password", ~M{user, conn} do
      vars = %{email: user.email, password: @password}
      conn = query_over_router(conn, @mutation, vars)

      assert %{"data" => %{"signIn" => %{"success" => true, "data" => actual}}} =
               json_response(conn, 200)

      assert get_session(conn) == %{"user_id" => user.id}
      assert actual["id"] == user.id
    end

    test "does not sign user in with invalid password", ~M{user, conn} do
      vars = %{email: user.email, password: "invalid"}
      conn = query_over_router(conn, @mutation, vars)

      assert %{"data" => %{"signIn" => %{"success" => false, "data" => nil}}} =
               json_response(conn, 200)

      assert get_session(conn) == %{}
    end
  end

  @mutation """
  mutation SignOut {
    signOut
  }
  """

  describe "signOut mutation" do
    test "signs user out when signed in", ~M{user, conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(%{user_id: user.id})
        |> query_over_router(@mutation, %{})

      assert %{"data" => %{"signOut" => true}} = json_response(conn, 200)
      assert get_session(conn) == %{}
    end
  end
end
