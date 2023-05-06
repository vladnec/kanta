defmodule Kanta.Gettext.Repo do
  @behaviour Gettext.Repo

  alias Kanta.Translations.{Domain, Locale, Message, PluralTranslation, SingularTranslation}
  alias Kanta.Translations

  @impl Gettext.Repo
  def init(_) do
    __MODULE__
  end

  @impl Gettext.Repo
  def get_translation(locale, domain, msgctxt, msgid, opts) do
    default_locale = Application.get_env(:kanta, :default_locale) || "en"

    with %Locale{id: locale_id} <-
           Translations.get_locale_by(%{"filter" => %{"iso639_code" => locale}}),
         %Domain{id: domain_id} <-
           Translations.get_domain_by(%{"filter" => %{"name" => domain}}),
         %Message{id: message_id} <-
           Translations.get_message_by(%{
             "filter" => %{"msgid" => msgid, "domain_id" => domain_id}
           }),
         %SingularTranslation{translated_text: text} <-
           Translations.get_singular_translation_by(%{
             "filter" => %{
               "locale_id" => locale_id,
               "message_id" => message_id
             }
           }) do
      if is_nil(text) do
        get_translation(default_locale, domain, msgctxt, msgid, opts)
      else
        {:ok, text}
      end
    else
      _ ->
        :not_found
    end
  end

  @impl Gettext.Repo
  def get_plural_translation(
        locale,
        domain,
        msgctxt,
        msgid,
        msgid_plural,
        plural_form,
        opts
      ) do
    default_locale = Application.get_env(:kanta, :default_locale) || "en"

    with %Locale{id: locale_id} <-
           Translations.get_locale_by(%{"filter" => %{"iso639_code" => locale}}),
         %Domain{id: domain_id} <-
           Translations.get_domain_by(%{"filter" => %{"name" => domain}}),
         %Message{id: message_id, plurals_header: plurals_header} <-
           Translations.get_message_by(%{
             "filter" => %{"msgid" => msgid_plural, "domain_id" => domain_id}
           }),
         {:ok, plurals_options} <- Expo.PluralForms.parse(plurals_header),
         nplural_index <- Expo.PluralForms.index(plurals_options, plural_form),
         %PluralTranslation{translated_text: text} <-
           Translations.get_plural_translation_by(%{
             "filter" => %{
               "locale_id" => locale_id,
               "message_id" => message_id,
               "nplural_index" => nplural_index
             }
           }) do
      if is_nil(text) do
        get_plural_translation(
          default_locale,
          domain,
          msgctxt,
          msgid,
          msgid_plural,
          plural_form,
          opts
        )
      else
        {:ok, text}
      end
    else
      _ ->
        :not_found
    end
  end
end
