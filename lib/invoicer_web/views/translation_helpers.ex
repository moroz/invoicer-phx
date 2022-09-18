defmodule InvoicerWeb.TranslationHelpers do
  import InvoicerWeb.Gettext

  @context InvoicerWeb.Gettext

  defmacro bdgettext(domain, key) do
    quote do
      locales = var!(assigns)[:locale]
      InvoicerWeb.Gettext.dgettext_noop(unquote(domain), unquote(key))

      Enum.map_join(locales, "/", fn locale ->
        dgettext_with_locale(locale, unquote(domain), unquote(key))
      end)
    end
  end

  def dgettext_with_locale(locale, domain, key) do
    Gettext.put_locale(@context, to_string(locale))
    Gettext.dgettext(@context, domain, key)
  end
end
