defmodule Invoicer.Invoices.InvoiceType do
  @values ["VAT Invoice", "Invoice", "Invoice (reverse charge)"]
  @values_atoms Enum.map(@values, &String.to_atom/1)

  defmacro values, do: Macro.expand(@values, __CALLER__)

  use EctoEnum, type: :invoice_type, enums: @values_atoms

  def is_reverse_charge(:"Invoice (reverse charge)"), do: true
  def is_reverse_charge(_), do: false
end
