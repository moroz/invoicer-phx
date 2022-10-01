defmodule Invoicer.Clients.Client do
  use Invoicer.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Invoicer.Users.User

  schema "clients" do
    field :address_line, :string
    field :city, :string
    field :name, :string
    field :postal_code, :string
    field :vat_id, :string
    field :bank_name, :string
    field :bic_code, :string
    field :account_no, :string
    belongs_to :user, Invoicer.Users.User

    timestamps()
  end

  @required ~w(name address_line city vat_id postal_code user_id)a
  @cast @required ++ ~w(account_no bic_code bank_name)a

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, @cast)
    |> validate_required(@required)
  end

  def for_user(queryable \\ __MODULE__, user)

  def for_user(queryable, %User{} = user) do
    where(queryable, [c], c.user_id == ^user.id)
  end

  def for_user(queryable, user_id) when is_binary(user_id) do
    where(queryable, [c], c.user_id == ^user_id)
  end
end
