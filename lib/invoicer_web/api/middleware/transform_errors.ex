defmodule InvoicerWeb.Api.Middleware.TransformErrors do
  use GraphQLTools.TransformErrors, gettext_module: InvoicerWeb.Gettext
end
