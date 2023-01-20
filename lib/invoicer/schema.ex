defmodule Invoicer.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, Uniq.UUID, autogenerate: {Uniq.UUID, :uuid6, []}}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
    end
  end
end
