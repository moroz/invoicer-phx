defmodule InvoicerWeb.Api.InvoiceTypes do
  use Absinthe.Schema.Notation

  object :invoice do
    field :id, non_null(:id)
    field :invoice_no, non_null(:string)
  end
end
