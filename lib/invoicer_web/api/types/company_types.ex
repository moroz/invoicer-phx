defmodule InvoicerWeb.Api.ClientTypes do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias InvoicerWeb.Api.ClientResolvers

  object :company do
    field :id, non_null(:id)
    field :address_line, non_null(:string)
    field :city, non_null(:string)
    field :name, non_null(:string)
    field :postal_code, :string
    field :vat_id, non_null(:string)

    timestamps()
  end

  input_object :company_params do
    field :address_line, non_null(:string)
    field :city, non_null(:string)
    field :name, non_null(:string)
    field :postal_code, :string
    field :vat_id, non_null(:string)
  end

  object :company_page do
    pagination_fields(:company)
  end

  object :company_mutation_result do
    mutation_result_fields(:company)
  end

  input_object :company_filter_params do
    standard_pagination_params()
  end

  object :company_queries do
    field :paginate_companies, non_null(:company_page) do
      arg(:params, non_null(:company_filter_params))
      resolve(&ClientResolvers.filter_and_paginate_companies/2)
      middleware(GraphQLTools.FormatPage)
    end

    field :company, :company do
      arg(:id, non_null(:id))
      resolve(&ClientResolvers.get_company/2)
    end
  end

  object :company_mutations do
    field :create_company, non_null(:company_mutation_result) do
      arg(:params, non_null(:company_params))
      resolve(&ClientResolvers.create_company/2)
    end
  end
end
