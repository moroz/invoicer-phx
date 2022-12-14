defmodule InvoicerWeb.TranslationHelpers do
  @context InvoicerWeb.Gettext

  defmacro bdgettext(domain, key, bindings \\ %{}, separator \\ "/", add_macro \\ true) do
    bindings = if bindings == %{}, do: Macro.escape(bindings), else: bindings

    macro =
      if add_macro do
        quote do
          InvoicerWeb.Gettext.dgettext_noop(unquote(domain), unquote(key))
          ""
        end
      else
        quote do: ""
      end

    translation =
      quote do
        locales = var!(assigns)[:locale]

        Enum.map_join(locales, unquote(separator), fn locale ->
          dgettext_with_locale(
            locale,
            unquote(domain),
            unquote(key),
            unquote(bindings)
          )
        end)
      end

    [macro, translation]
  end

  defmacro ldgettext(locale, domain, key, bindings \\ %{}) do
    quote do
      InvoicerWeb.Gettext.dgettext_noop(unquote(domain), unquote(key))

      dgettext_with_locale(
        unquote(locale),
        unquote(domain),
        unquote(key),
        unquote(bindings)
      )
    end
  end

  defmacro format_date(date) do
    quote do
      locales = var!(assigns)[:locale]
      locale = List.first(locales)
      InvoicerWeb.Gettext.gettext_noop("date_format_short")
      format_date(locale, unquote(date))
    end
  end

  def dgettext_with_locale(locale, domain, key, bindings \\ %{}) do
    Gettext.put_locale(@context, to_string(locale))

    @context
    |> Gettext.dgettext(domain, to_string(key), bindings)
    |> ElixirLatex.LatexHelpers.escape_latex()
  end

  def format_date(locale, %Date{} = date) do
    Gettext.put_locale(@context, to_string(locale))
    template = Gettext.gettext(@context, "date_format_short")

    date
    |> Calendar.strftime(template)
    |> ElixirLatex.LatexHelpers.escape_latex()
  end
end
