defmodule InvoicerWeb.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(InvoicerWeb.Api.InvoiceTypes)
  import_types(InvoicerWeb.Api.ClientTypes)
  import_types(InvoicerWeb.Api.UserTypes)
  import_types(GraphQLTools.ErrorTypes)
  import_types(GraphQLTools.PaginationTypes)

  query do
    import_fields(:invoice_queries)
    import_fields(:user_queries)
    import_fields(:client_queries)
  end

  mutation do
    import_fields(:invoice_mutations)
    import_fields(:client_mutations)
    import_fields(:user_mutations)
  end

  alias InvoicerWeb.Api.Middleware.TransformErrors
  alias InvoicerWeb.Api.Middleware.RestrictAccess
  alias GraphQLTools.ResolutionWithErrorBoundary

  @public_queries [:current_user]
  def middleware(middleware, %{identifier: id}, %{identifier: :query})
      when id in @public_queries do
    middleware
  end

  @public_mutations [:sign_in, :sign_out, :sign_up]
  def middleware(middleware, %{identifier: id}, %{identifier: :mutation})
      when id in @public_mutations do
    middleware
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :query}) do
    List.flatten([
      RestrictAccess,
      ResolutionWithErrorBoundary.replace_resolution_middleware(middleware)
    ])
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    List.flatten([
      RestrictAccess,
      ResolutionWithErrorBoundary.replace_resolution_middleware(middleware),
      TransformErrors
    ])
  end

  def middleware(middleware, _field, _object), do: middleware
end
