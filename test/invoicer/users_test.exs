defmodule Invoicer.UsersTest do
  use Invoicer.DataCase

  alias Invoicer.Users

  describe "users" do
    alias Invoicer.Users.User

    import Invoicer.UsersFixtures

    @invalid_attrs %{email: nil, password_hash: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.email == valid_attrs.email
      assert user.password_hash
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "new@example.com",
        password: "new_password",
        password_confirmation: "new_password"
      }

      assert {:ok, %User{} = updated} = Users.update_user(user, update_attrs)
      assert updated.email == update_attrs.email
      assert updated.password_hash != user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end
  end
end
