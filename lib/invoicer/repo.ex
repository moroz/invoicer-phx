defmodule Invoicer.Repo do
  use Ecto.Repo,
    otp_app: :invoicer,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
