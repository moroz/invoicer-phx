defmodule InvoicerWeb.TranslationHelpers do
  import InvoicerWeb.Gettext

  @context InvoicerWeb.Gettext

  defmacro bdgettext(domain, key, bindings \\ %{}, separator \\ "/") do
    quote do
      locales = var!(assigns)[:locale]
      InvoicerWeb.Gettext.dgettext_noop(unquote(domain), unquote(key))

      Enum.map_join(locales, unquote(separator), fn locale ->
        dgettext_with_locale(
          locale,
          unquote(domain),
          unquote(key),
          unquote(Macro.escape(bindings))
        )
      end)
    end
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

  def dgettext_with_locale(locale, domain, key, bindings \\ %{}) do
    Gettext.put_locale(@context, to_string(locale))
    Gettext.dgettext(@context, domain, key, bindings)
  end
end
