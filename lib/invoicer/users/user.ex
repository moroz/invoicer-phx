defmodule Invoicer.Users.User do
  use Invoicer.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :invoices, Invoicer.Invoices.Invoice

    timestamps()
  end

  @required ~w(email)a
  @cast @required ++ ~w(password password_confirmation)a

  @doc false
  def base_changeset(user, attrs) do
    user
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
  end

  def update_changeset(user, attrs) do
    user
    |> base_changeset(attrs)
    |> hash_password()
  end

  def registration_changeset(user, attrs) do
    user
    |> base_changeset(attrs)
    |> validate_required([:password])
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        password_hash = Bcrypt.hash_pwd_salt(password)

        changeset
        |> put_change(:password_hash, password_hash)
        |> delete_change(:password)
        |> delete_change(:password_confirmation)
    end
  end

  defp hash_password(changeset), do: changeset
end
