defmodule Invoicer.Companies.Company do
  use Invoicer.Schema
  import Ecto.Changeset

  schema "companies" do
    field :address_line, :string
    field :city, :string
    field :name, :string
    field :postal_code, :string
    field :vat_id, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :address_line, :city, :vat_id, :postal_code])
    |> validate_required([:name, :address_line, :city, :vat_id, :postal_code])
  end
end
