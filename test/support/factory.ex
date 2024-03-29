defmodule Invoicer.Factory do
  use ExMachina.Ecto, repo: Invoicer.Repo

  def random_email do
    rand =
      :crypto.strong_rand_bytes(5)
      |> Base.encode16(case: :lower)

    "#{rand}@example.com"
  end

  def invoice_no(number) do
    number =
      number
      |> to_string()
      |> String.pad_leading(2, "0")

    date = Date.utc_today() |> Calendar.strftime("/%m/%y")

    number <> date
  end

  @password "foobar"
  @password_hash Bcrypt.hash_pwd_salt(@password)

  def user_factory do
    %Invoicer.Users.User{
      email: random_email(),
      password_hash: @password_hash
    }
  end

  def client_factory do
    %Invoicer.Clients.Client{
      user: build(:user),
      name: "Dunder Mifflin Paper Inc.",
      city: "Scranton, PA",
      postal_code: "18503",
      vat_id: "US123456789",
      account_no: "PL 20 1020 2030 0000 5529 0728 9913",
      bic_code: "BPKOPLPW",
      address_line: "201 Lackawanna Ave"
    }
  end

  def line_item_factory do
    %Invoicer.LineItems.LineItem{
      invoice: build(:invoice),
      description: "Office paper",
      unit_net_price: 42,
      vat_rate: "5%",
      position: sequence(:item_position, & &1)
    }
  end

  def invoice_factory do
    user = insert(:user)

    %Invoicer.Invoices.Invoice{
      user: user,
      seller: build(:client, user: user),
      buyer: build(:client, user: user),
      invoice_no: sequence(:invoice_no, &invoice_no/1),
      date_of_issue: Date.utc_today(),
      date_of_sale: Date.utc_today(),
      place_of_issue: "Scranton, PA",
      currency: "USD",
      locale: [:en],
      payment_method: :transfer,
      invoice_type: "Invoice"
    }
  end

  def with_line_items(invoice) do
    %{invoice | line_items: build_list(2, :line_item, invoice: nil)}
  end
end
