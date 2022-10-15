defmodule Invoicer.Invoices.BankRateTest do
  use ExUnit.Case

  alias Invoicer.Invoices.BankRate

  @valid_attrs %{"no" => "199/A/NBP/2022", "effective_date" => "2022-10-13", "mid" => 0.6941}

  test "changeset/2 casts correct bank response" do
    changeset = BankRate.changeset(%BankRate{}, @valid_attrs)
    assert changeset.valid?
    %BankRate{} = applied = Ecto.Changeset.apply_action!(changeset, :cast)
    assert applied.effective_date == ~D[2022-10-13]
    assert applied.no == @valid_attrs["no"]
    assert applied.mid == Decimal.new("0.6941")
  end
end
