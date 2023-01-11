defmodule Invoicer.Repo do
  use Ecto.Repo,
    otp_app: :invoicer,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20

  def count(queryable) do
    aggregate(queryable, :count)
  end
end
