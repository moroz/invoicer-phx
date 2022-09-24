defmodule InvoicerWeb.Api.InvoiceTypes do
  use Absinthe.Schema.Notation
  alias InvoicerWeb.Api.InvoiceResolvers

  import GraphQLTools.SchemaHelpers
  import InvoicerWeb.Api.Middleware.LazyPreload

  enum :locale do
    value(:pl)
    value(:de)
    value(:en)
  end

  object :invoice do
    field :id, non_null(:id)
    field :invoice_no, non_null(:string)
    field :date_of_issue, non_null(:date)
    field :date_of_sale, non_null(:date)
    field :gross_total, non_null(:decimal)
    field :place_of_issue, non_null(:string)
    field :currency, non_null(:string)
    field :account_no, :string
    field :locale, non_null(list_of(non_null(:locale)))

    field :seller_id, non_null(:id)
    field :buyer_id, non_null(:id)

    field :buyer, non_null(:company) do
      lazy_preload()
    end

    field :seller, non_null(:company) do
      lazy_preload()
    end
  end

  object :invoice_mutation_result do
    mutation_result_fields(:invoice)
  end

  input_object :invoice_params do
    field :invoice_no, non_null(:string)
    field :date_of_issue, non_null(:date)
    field :date_of_sale, non_null(:date)
    field :place_of_issue, non_null(:string)
    field :currency, non_null(:string)
    field :account_no, :string
    field :locale, non_null(list_of(non_null(:locale)))
  end

  object :invoice_queries do
    field :invoice, :invoice do
      arg(:id, non_null(:id))
      resolve(&InvoiceResolvers.get_invoice/2)
    end
  end

  object :invoice_mutations do
    field :create_invoice, non_null(:invoice_mutation_result) do
      arg(:params, non_null(:invoice_params))
      resolve(&InvoiceResolvers.create_invoice/2)
    end
  end
end
