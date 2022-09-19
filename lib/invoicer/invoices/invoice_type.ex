defmodule Invoicer.Invoices.InvoiceType do
  @values ["Invoice", "Invoice (reverse charge)"]
  require InvoicerWeb.Gettext
  @values_atoms Enum.map(@values, &String.to_atom/1)

  defmacro values, do: Macro.expand(@values, __CALLER__)

  use EctoEnum, type: :invoice_type, enums: @values_atoms
end
