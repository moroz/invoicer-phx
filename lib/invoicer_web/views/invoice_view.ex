defmodule InvoicerWeb.InvoiceView do
  use InvoicerWeb, :view
  import InvoicerWeb.TranslationHelpers
  alias Invoicer.LineItems.LineItem

  defmacro table_header(content) do
    ["\\thead{", content, "}"]
  end
end
