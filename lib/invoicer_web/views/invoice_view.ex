defmodule InvoicerWeb.InvoiceView do
  use InvoicerWeb, :view
  import InvoicerWeb.TranslationHelpers
  alias Invoicer.Invoices.Calculator
  import ElixirLatex.LatexHelpers

  defmacro table_header(content) do
    ["\\thead[X]{\\centering ", content, "}"]
  end

  def format_price(price) do
    price
    |> Decimal.round(2)
    |> Decimal.to_string()
    |> String.replace(".", ",")
  end
end
