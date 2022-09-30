defmodule Invoicer.Companies.Company do
  use Invoicer.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Invoicer.Users.User

  schema "companies" do
    field :address_line, :string
    field :city, :string
    field :name, :string
    field :postal_code, :string
    field :vat_id, :string
    belongs_to :user, Invoicer.Users.User

    timestamps()
  end

  @required ~w(name address_line city vat_id postal_code user_id)a

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @required)
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
