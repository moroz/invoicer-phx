# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Invoicer.Repo.insert!(%Invoicer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

alias Invoicer.Repo
alias Invoicer.Clients
alias Invoicer.Clients.Client
alias Invoicer.Invoices
alias Invoicer.Invoices.Invoice
alias Invoicer.LineItems
alias Invoicer.LineItems.LineItem
alias Invoicer.Users
alias Invoicer.Users.User

Repo.transaction(fn ->
  Repo.delete_all(User)
  Repo.delete_all(LineItem)
  Repo.delete_all(Invoice)
  Repo.delete_all(Client)

  {:ok, user} =
    Users.create_user(%{
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    })

  {:ok, buyer} =
    Clients.create_client(%{
      name: "ACME Corp.",
      city: "New York",
      postal_code: "12345",
      vat_id: "PL123456789",
      address_line: "42 Infinity Drive",
      user_id: user.id,
      template_type: :buyer
    })

  {:ok, seller} =
    Clients.create_client(%{
      name: "Satorisoft Bank",
      city: "Tokyo",
      postal_code: "00-819",
      vat_id: "JP123456789",
      address_line: "42 Sun Yat-sen Rd.",
      template_type: :seller,
      user_id: user.id
    })

  invoice_no = DateTime.utc_now() |> Calendar.strftime("01/%m/%Y")
  date = Timex.today() |> Timex.end_of_month()

  period_start = Timex.today() |> Timex.beginning_of_month()

  period_formatted =
    [
      Calendar.strftime(period_start, "%d.%m.%Y"),
      Calendar.strftime(date, "%d.%m.%Y")
    ]
    |> Enum.join("--")

  {:ok, invoice} =
    Invoices.create_invoice(%{
      user_id: user.id,
      buyer_template_id: buyer.id,
      seller_template_id: seller.id,
      invoice_no: invoice_no,
      date_of_sale: date,
      date_of_issue: date,
      place_of_issue: seller.city,
      gross_total: 0,
      currency: "EUR",
      account_no: "PL 20 1020 2030 0000 5529 0728 9913\nBIC: BPKOPLPW",
      locale: [:de, :pl],
      payment_method: :transfer,
      invoice_type: :Invoice
    })

  LineItems.create_line_item(%{
    invoice_id: invoice.id,
    description: "Software development services, period: #{period_formatted}",
    unit_net_price: Decimal.new("5833.33"),
    vat_rate: "np.",
    position: 1
  })
end)
