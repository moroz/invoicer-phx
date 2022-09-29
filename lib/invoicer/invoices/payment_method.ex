defmodule Invoicer.Invoices.PaymentMethod do
  @values ["cash", "transfer", "credit card", "payment card"]
  @values_atoms Enum.map(@values, &String.to_atom/1)

  defmacro values, do: Macro.expand(@values, __CALLER__)

  use EctoEnum, type: :payment_method, enums: @values_atoms
end
