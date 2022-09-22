defmodule Invoicer.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Users` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  import Invoicer.Factory

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    insert(:user, attrs)
  end
end
