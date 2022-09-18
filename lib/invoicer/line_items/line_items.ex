defmodule Invoicer.LineItems do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.LineItems.LineItem

  def create_line_item(attrs) do
    %LineItem{}
    |> LineItem.changeset(attrs)
    |> Repo.insert()
  end
end
