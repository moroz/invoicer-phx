defmodule Invoicer.Repo do
  use Ecto.Repo,
    otp_app: :invoicer,
    adapter: Ecto.Adapters.Postgres
end
