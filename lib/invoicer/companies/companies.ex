defmodule Invoicer.Companies do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.Companies.Company

  def create_company(attrs) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end
end
