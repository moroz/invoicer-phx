defmodule Invoicer.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Invoicer.Repo

  alias Invoicer.Users.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def authenticate_user_by_email_password(email, password) do
    User
    |> Repo.get_by(email: email)
    |> Bcrypt.check_pass(password, hide_user: true)
  end
end
