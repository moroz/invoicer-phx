defmodule InvoicerWeb.Api.ClientTypes do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias InvoicerWeb.Api.ClientResolvers

  object :client do
    field :id, non_null(:id)
    field :address_line, :string
    field :city, :string
    field :name, :string
    field :postal_code, :string
    field :vat_id, :string
    field :bank_name, :string
    field :bic_code, :string
    field :account_no, :string

    timestamps()
  end

  input_object :client_params do
    field :address_line, :string
    field :city, :string
    field :name, non_null(:string)
    field :postal_code, :string
    field :vat_id, :string
    field :bank_name, :string
    field :bic_code, :string
    field :account_no, :string
  end

  object :client_page do
    pagination_fields(:client)
  end

  object :client_mutation_result do
    mutation_result_fields(:client)
  end

  input_object :client_filter_params do
    standard_pagination_params()
  end

  object :client_queries do
    field :paginate_clients, non_null(:client_page) do
      arg(:params, non_null(:client_filter_params))
      resolve(&ClientResolvers.filter_and_paginate_clients/2)
      middleware(GraphQLTools.FormatPage)
    end

    field :client, :client do
      arg(:id, non_null(:id))
      resolve(&ClientResolvers.get_client/2)
    end
  end

  object :client_mutations do
    field :create_client, non_null(:client_mutation_result) do
      arg(:params, non_null(:client_params))
      resolve(&ClientResolvers.create_client/2)
    end

    field :update_client, non_null(:client_mutation_result) do
      arg(:id, non_null(:id))
      arg(:params, non_null(:client_params))
      resolve(&ClientResolvers.update_client/2)
    end
  end
end
