defmodule Invoicer.Factory do
  use ExMachina.Ecto, repo: Invoicer.Repo

  def random_email do
    rand =
      :crypto.strong_rand_bytes(5)
      |> Base.encode16(case: :lower)

    "#{rand}@example.com"
  end

  @password "foobar"
  @password_hash Bcrypt.hash_pwd_salt(@password)

  def user_factory do
    %Invoicer.Users.User{
      email: random_email(),
      password_hash: @password_hash
    }
  end
end
