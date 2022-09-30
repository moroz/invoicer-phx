defmodule Invoicer.Companies do
  import Ecto.Query, warn: false
  alias Invoicer.Repo
  alias Invoicer.Companies.Company
  alias Invoicer.Users.User

  def get_user_company(user, id) do
    user
    |> Company.for_user()
    |> Repo.get(id)
  end

  def create_company(attrs) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_company(%User{} = user, attrs) do
    %Company{user_id: user.id}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  def filter_and_paginate_companies(%User{} = user, params) when is_map(params) do
    user
    |> Company.for_user()
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

  defp do_filter_by_params(_, q), do: q
end
