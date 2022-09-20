defmodule Invoicer.Invoices.Locale do
  @values ~w(pl de en)a

  use EctoEnum, type: :locale, enums: @values
end
