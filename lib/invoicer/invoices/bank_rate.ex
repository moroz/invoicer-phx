defmodule Invoicer.Invoices.BankRate do
  @moduledoc """
  Data structure representing daily exchange rates of the Polish National Bank.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :no, :string
    field :effective_date, :date
    field :mid, :decimal
  end

  @required ~w(no effective_date mid)a

  def changeset(record, attrs) do
    record
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
