defmodule InvoicerWeb.Api.InvoiceTypes do
  use Absinthe.Schema.Notation
  alias InvoicerWeb.Api.InvoiceResolvers

  import GraphQLTools.SchemaHelpers
  import InvoicerWeb.Api.Middleware.LazyPreload

  enum :vat_rate do
    value(:np, as: :"np.")
    value(:zw, as: :"zw.")
    value(:oo, as: :"o.o.")
    value(:zero, as: :"0%")
    value(:five, as: :"5%")
    value(:seven, as: :"7%")
    value(:eight, as: :"8%")
    value(:twenty_three, as: :"23%")
  end

  enum :invoice_type do
    value(:invoice, as: :Invoice)
    value(:invoice_rc, as: :"Invoice (reverse charge)")
    value(:vat_invoice, as: :"VAT Invoice")
  end

  enum :payment_method do
    value(:card)
    value(:transfer)
    value(:credit_card, as: :"credit card")
    value(:payment_card, as: :"payment card")
  end

  enum :locale do
    value(:pl)
    value(:de)
    value(:en)
  end

  object :line_item do
    field :id, non_null(:id)
    field :description, non_null(:string)
    field :unit, :string
    field :quantity, non_null(:decimal)
    field :unit_net_price, non_null(:decimal)
    field :vat_rate, non_null(:vat_rate)
  end

  object :invoice do
    field :id, non_null(:id)
    field :invoice_no, non_null(:string)
    field :date_of_issue, non_null(:date)
    field :date_of_sale, non_null(:date)
    field :gross_total, non_null(:decimal)
    field :net_total, non_null(:decimal)
    field :place_of_issue, non_null(:string)
    field :currency, non_null(:string)
    field :account_no, :string
    field :locale, non_null(list_of(non_null(:locale)))
    field :invoice_type, non_null(:invoice_type)
    field :payment_method, non_null(:payment_method)

    field :seller_id, non_null(:id)
    field :buyer_id, non_null(:id)

    field :buyer, non_null(:client) do
      lazy_preload()
    end

    field :seller, non_null(:client) do
      lazy_preload()
    end

    field :line_items, non_null(list_of(non_null(:line_item))) do
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
    field :invoice_type, non_null(:invoice_type)
    field :payment_method, non_null(:payment_method)
    field :locale, non_null(list_of(non_null(:locale)))
    field :buyer_id, :id
    field :seller_id, :id
    field :buyer, :client_params
    field :seller, :client_params
    field :line_items, list_of(non_null(:line_item_params))
  end

  input_object :line_item_params do
    field :description, non_null(:string)
    field :unit, :string
    field :quantity, non_null(:decimal), default_value: Decimal.new(1)
    field :unit_net_price, non_null(:decimal)
    field :vat_rate, non_null(:vat_rate)
  end

  object :invoice_page do
    pagination_fields(:invoice)
  end

  input_object :invoice_filter_params do
    standard_pagination_params()
  end

  object :invoice_queries do
    field :invoice, :invoice do
      arg(:id, non_null(:id))
      resolve(&InvoiceResolvers.get_invoice/2)
    end

    field :paginate_invoices, :invoice_page do
      arg(:params, non_null(:invoice_filter_params))
      resolve(&InvoiceResolvers.filter_and_paginate_invoices/2)
      middleware(GraphQLTools.FormatPage)
    end
  end

  object :invoice_mutations do
    field :create_invoice, non_null(:invoice_mutation_result) do
      arg(:params, non_null(:invoice_params))
      resolve(&InvoiceResolvers.create_invoice/2)
    end
  end
end
