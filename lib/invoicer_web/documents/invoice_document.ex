defmodule InvoicerWeb.InvoiceDocument do
  use ElixirLatex.Document,
    view: InvoicerWeb.InvoiceView,
    view: {InvoicerWeb.LayoutView, :document}
end
