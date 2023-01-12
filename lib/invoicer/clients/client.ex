defmodule Invoicer.Clients.Client do
  use Invoicer.Schema
  import Ecto.Changeset
  import Ecto.Query
  import EctoEnum
  alias Invoicer.Users.User

  defenum(TemplateType, :client_template_type, [:buyer, :seller])

  schema "clients" do
    field :address_line, :string
    field :city, :string
    field :name, :string
    field :postal_code, :string
    field :vat_id, :string
    field :bank_name, :string
    field :bic_code, :string
    field :account_no, :string
    field :template_type, TemplateType
    field :is_default_template, :boolean
    belongs_to :user, Invoicer.Users.User

    timestamps()
  end

  @required ~w(name)a
  @cast @required ++
          ~w(account_no bic_code bank_name user_id address_line
             postal_code vat_id city template_type is_default_template)a

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, @cast)
    |> validate_required(@required)
  end

  def from_template(%__MODULE__{} = client) do
    client
    |> Map.take(__schema__(:fields))
    |> Map.drop([:id, :template_type, :is_default_template])
  end

  def templates(queryable \\ __MODULE__) do
    where(queryable, [c], not is_nil(c.template_type))
  end

  def for_user(queryable \\ __MODULE__, user)

  def for_user(queryable, %User{} = user) do
    where(queryable, [c], c.user_id == ^user.id)
  end

  def for_user(queryable, user_id) when is_binary(user_id) do
    where(queryable, [c], c.user_id == ^user_id)
  end
end
