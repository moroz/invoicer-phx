defmodule Invoicer.ClientsTest do
  use Invoicer.DataCase, async: true

  alias Invoicer.Clients

  setup do
    user = insert(:user)

    ~M{user}
  end

  test "user can have multiple non-default templates", ~M{user} do
    insert(:client, user: user, template_type: :buyer)
    insert(:client, user: user, template_type: :buyer)

    assert Repo.count(Ecto.assoc(user, :clients)) == 2
  end

  test "user can have one default template for each template type", ~M{user} do
    buyer = insert(:client, user: user, template_type: :buyer, is_default_template: true)
    seller = insert(:client, user: user, template_type: :seller, is_default_template: true)

    assert Repo.count(Ecto.assoc(user, :clients)) == 2

    buyer = Repo.reload(buyer)
    assert buyer.is_default_template

    seller = Repo.reload(seller)
    assert seller.is_default_template
  end

  test "creating a new default template overrides the existing one", ~M{user} do
    old = insert(:client, user: user, template_type: :buyer, is_default_template: true)
    assert old.is_default_template

    new = insert(:client, user: user, template_type: :buyer, is_default_template: true)

    assert Repo.count(Ecto.assoc(user, :clients)) == 2

    old = Repo.reload(old)
    refute old.is_default_template

    new = Repo.reload(new)
    assert new.is_default_template
  end

  test "promoting a client to default template overrides the existing one", ~M{user} do
    old = insert(:client, user: user, template_type: :buyer, is_default_template: true)
    assert old.is_default_template

    new = insert(:client, user: user, template_type: :buyer, is_default_template: false)

    old = Repo.reload(old)
    assert old.is_default_template

    {:ok, new} = Clients.update_client(new, %{is_default_template: true})

    assert new.is_default_template
    old = Repo.reload(old)
    refute old.is_default_template
  end
end
