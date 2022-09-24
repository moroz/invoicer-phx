defmodule InvoicerWeb.Api.CompanyTypes do
  use Absinthe.Schema.Notation

  object :company do
    field :id, non_null(:id)
  end
end
