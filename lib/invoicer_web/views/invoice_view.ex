defmodule InvoicerWeb.InvoiceView do
  use InvoicerWeb, :view
  import InvoicerWeb.TranslationHelpers

  defmacro table_header(content) do
    ["\\thead{", content, "}"]
  end
end
