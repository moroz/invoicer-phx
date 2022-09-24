defmodule InvoicerWeb.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(InvoicerWeb.Api.InvoiceTypes)
  import_types(InvoicerWeb.Api.CompanyTypes)
  import_types(GraphQLTools.ErrorTypes)
  import_types(GraphQLTools.PaginationTypes)

  query do
    import_fields(:invoice_queries)
  end

  alias InvoicerWeb.Api.Middleware.TransformErrors

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :query}) do
    GraphQLTools.ResolutionWithErrorBoundary.replace_resolution_middleware(middleware)
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    List.flatten([
      GraphQLTools.ResolutionWithErrorBoundary.replace_resolution_middleware(middleware),
      TransformErrors
    ])
  end

  def middleware(middleware, _field, _object), do: middleware
end
