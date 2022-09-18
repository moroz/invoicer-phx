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
alias Invoicer.Companies
alias Invoicer.Companies.Company
alias Invoicer.Invoices
alias Invoicer.Invoices.Invoice
alias Invoicer.LineItems.LineItem
alias Invoicer.LineItems.LineItem.VatRate

Repo.transaction(fn ->
  Repo.delete_all(LineItem)
  Repo.delete_all(Invoice)
  Repo.delete_all(Company)

  {:ok, buyer} =
    Companies.create_company(%{
      name: "ACME Corp.",
      city: "New York",
      postal_code: "12345",
      vat_id: "PL123456789",
      address_line: "42 Infinity Drive"
    })

  {:ok, seller} =
    Companies.create_company(%{
      name: "Satorisoft Bank",
      city: "Tokyo",
      postal_code: "00-819",
      vat_id: "JP123456789",
      address_line: "42 Sun Yat-sen Rd."
    })

  invoice_no = DateTime.utc_now() |> Calendar.strftime("01/%m/%Y")
  date = Timex.today() |> Timex.end_of_month()

  {:ok, invoice} =
    Invoices.create_invoice(%{
      buyer_id: buyer.id,
      seller_id: seller.id,
      invoice_no: invoice_no,
      date_of_sale: date,
      date_of_issue: date,
      place_of_issue: seller.city,
      gross_total: 0
    })
end)
