defmodule Invoicer.Repo.Migrations.AddPaymentMethodAndInvoiceTypeToInvoices do
  use Ecto.Migration

  def change do
    Invoicer.Invoices.PaymentMethod.create_type()
    Invoicer.Invoices.InvoiceType.create_type()

    alter table(:invoices) do
      add :payment_method, :payment_method, null: false, default: "transfer"
      add :invoice_type, :invoice_type, null: false, default: "Invoice"
    end
  end
end
