defmodule InvoicerWeb.Api.CompanyTypes do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias InvoicerWeb.Api.CompanyResolvers

  object :company do
    field :id, non_null(:id)
  end

  object :company_page do
    pagination_fields(:company)
  end

  input_object :company_filter_params do
    standard_pagination_params()
  end

  object :company_queries do
    field :paginate_companies, non_null(:company_page) do
      arg(:params, non_null(:company_filter_params))

      resolve(&CompanyResolvers.filter_and_paginate_companies/2)
    end
  end
end
