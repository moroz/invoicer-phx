defmodule InvoicerWeb.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(InvoicerWeb.Api.InvoiceTypes)

  query do
  end
end
