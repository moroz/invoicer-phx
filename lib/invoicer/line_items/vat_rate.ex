defmodule Invoicer.LineItems.LineItem.VatRate do
  @values ["np.", "zw.", "o.o.", "0%", "5%", "7%", "8%", "23%"]
  @values_atoms Enum.map(@values, &String.to_atom/1)

  @zero_values Enum.slice(@values, 0, 4) ++ Enum.slice(@values_atoms, 0, 4)
  @non_zero_values Enum.slice(@values, 4, 4)

  use EctoEnum,
    type: :vat_rate,
    enums: @values_atoms

  def numeric_value(zero) when zero in @zero_values, do: Decimal.new(0)

  for value <- @non_zero_values do
    atom_value = String.to_atom(value)
    {int_value, _} = Integer.parse(value)
    decimal = Decimal.div(int_value, 100) |> Macro.escape()

    def numeric_value(unquote(value)), do: unquote(decimal)
    def numeric_value(unquote(atom_value)), do: unquote(decimal)
  end
end
