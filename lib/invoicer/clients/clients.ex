defmodule Invoicer.Clients do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.Clients.Client
  alias Invoicer.Users.User

  def get_user_client(user, id) do
    user
    |> Client.for_user()
    |> Repo.get(id)
  end

  def get_user_client!(user, id) do
    user
    |> Client.for_user()
    |> Repo.get!(id)
  end

  def get_user_client_template(user, id) do
    user
    |> Client.for_user()
    |> Client.templates()
    |> Repo.get(id)
  end

  def create_client(attrs) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  def update_client(client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  def create_user_client(%User{} = user, attrs) do
    %Client{user_id: user.id}
    |> Client.template_changeset(attrs)
    |> Repo.insert()
  end

  def filter_and_paginate_clients(%User{} = user, params) when is_map(params) do
    user
    |> Client.for_user()
    |> Client.templates()
    |> filter_by_params(params)
    |> Repo.paginate(params)
  end

  defp filter_by_params(queryable, params) do
    Enum.reduce(params, queryable, &do_filter_by_params/2)
  end

  defp do_filter_by_params({:q, name}, q) do
    ilike_clause = "%#{name}%"
    where(q, [c], ilike(c.name, ^ilike_clause))
  end

  defp do_filter_by_params({:template_type, type}, q) do
    where(q, [c], c.template_type == ^type)
  end

  defp do_filter_by_params(_, q), do: q
end
