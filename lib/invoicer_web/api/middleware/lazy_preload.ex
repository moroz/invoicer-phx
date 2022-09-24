defmodule InvoicerWeb.Api.Middleware.LazyPreload do
  use GraphQLTools.LazyPreload, repo: Invoicer.Repo
end
