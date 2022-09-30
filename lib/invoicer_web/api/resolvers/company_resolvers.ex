defmodule InvoicerWeb.Api.ClientResolvers do
  alias Invoicer.Clients
  import ShorterMaps

  def filter_and_paginate_companies(~M{params}, %{context: %{current_user: user}}) do
    {:ok, Clients.filter_and_paginate_companies(user, params)}
  end

  def create_client(~M{params}, %{context: %{current_user: user}}) do
    Clients.create_user_client(user, params)
  end

  def get_client(~M{id}, %{context: %{current_user: user}}) do
    {:ok, Clients.get_user_client(user, id)}
  end
end
