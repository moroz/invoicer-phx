defmodule InvoicerWeb.InvoiceDocument do
  use ElixirLatex.Document,
    view: InvoicerWeb.InvoiceView,
    view: {InvoicerWeb.LayoutView, :document}

  alias ElixirLatex.Job

  def generate(locales) do
    new()
    |> assign_locale(locales)
    |> Job.render("invoice.tex")
  end

  defguard is_locale(locale) when is_binary(locale) or is_atom(locale)

  def assign_locale(%Job{} = job, locale) when is_locale(locale) do
    job
    |> Job.assign(:locale, [locale])
    |> Job.assign(:first_locale, locale)
    |> Job.assign(:second_locale, nil)
  end

  def assign_locale(%Job{} = job, [first, second] = locales)
      when is_locale(first) and is_locale(second) do
    job
    |> Job.assign(:locale, locales)
    |> Job.assign(:first_locale, first)
    |> Job.assign(:second_locale, second)
  end
end
