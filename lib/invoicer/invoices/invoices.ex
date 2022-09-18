defmodule Invoicer.Invoices do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.Invoices.Invoice

  def create_invoice(attrs) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end
end
