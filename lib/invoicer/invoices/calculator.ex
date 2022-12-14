defmodule Invoicer.Invoices.Calculator do
  alias Invoicer.Invoices.Invoice
  alias Invoicer.LineItems.LineItem
  alias Invoicer.LineItems.LineItem.VatRate
  import Ecto.Changeset

  def group_by_vat_rate(items) when is_list(items) do
    items
    |> Enum.group_by(& &1.vat_rate)
    |> Enum.sort_by(fn {vat_rate, _} -> VatRate.numeric_value(vat_rate) end)
  end

  def total_net_price([]), do: Decimal.new(0)

  def total_net_price(items) when is_list(items) do
    items
    |> Enum.map(&total_net_price/1)
    |> Enum.reduce(&Decimal.add/2)
  end

  def total_net_price(%Ecto.Changeset{} = changeset) do
    quantity = get_field(changeset, :quantity)
    unit_net_price = get_field(changeset, :unit_net_price)
    Decimal.mult(quantity, unit_net_price)
  end

  def total_net_price(%LineItem{} = item) do
    Decimal.mult(item.quantity, item.unit_net_price)
  end

  def total_net_price(%Invoice{line_items: items}) do
    total_net_price(items)
  end

  def vat_amount(%LineItem{} = item) do
    vat_rate = VatRate.numeric_value(item.vat_rate)

    item
    |> total_net_price()
    |> Decimal.mult(vat_rate)
  end

  def vat_amount(%Invoice{line_items: items}), do: vat_amount(items)

  def vat_amount(%Ecto.Changeset{} = changeset) do
    vat_rate = changeset |> get_field(:vat_rate) |> VatRate.numeric_value()

    changeset
    |> total_net_price()
    |> Decimal.mult(vat_rate)
  end

  def vat_amount([]), do: Decimal.new(0)

  def vat_amount(items) when is_list(items) do
    items
    |> Enum.map(&vat_amount/1)
    |> Enum.reduce(&Decimal.add/2)
  end

  def total_gross_price([]), do: Decimal.new(0)

  def total_gross_price(items) when is_list(items) do
    items
    |> Enum.map(&total_gross_price/1)
    |> Enum.reduce(&Decimal.add/2)
  end

  def total_gross_price(%Invoice{line_items: items}), do: total_gross_price(items)

  def total_gross_price(%LineItem{} = item) do
    Decimal.add(total_net_price(item), vat_amount(item))
  end

  def total_gross_price(%Ecto.Changeset{} = changeset) do
    Decimal.add(total_net_price(changeset), vat_amount(changeset))
  end
end
