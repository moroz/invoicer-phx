defmodule InvoicerWeb.Api.ClientResolvers do
  alias Invoicer.Clients
  import ShorterMaps

  def filter_and_paginate_companies(~M{params}, %{context: %{current_user: user}}) do
    {:ok, Clients.filter_and_paginate_companies(user, params)}
  end

  def create_company(~M{params}, %{context: %{current_user: user}}) do
    Clients.create_user_company(user, params)
  end

  def get_company(~M{id}, %{context: %{current_user: user}}) do
    {:ok, Clients.get_user_company(user, id)}
  end
end
