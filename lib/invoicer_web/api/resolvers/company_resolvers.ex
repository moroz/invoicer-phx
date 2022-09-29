defmodule InvoicerWeb.Api.CompanyResolvers do
  alias Invoicer.Companies
  import ShorterMaps

  def filter_and_paginate_companies(~M{params}, %{context: %{current_user: user}}) do
    {:ok, Companies.filter_and_paginate_companies(user, params)}
  end

  def create_company(~M{params}, %{context: %{current_user: user}}) do
    Companies.create_user_company(user, params)
  end
end
