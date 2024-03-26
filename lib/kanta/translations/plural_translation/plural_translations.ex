defmodule Kanta.Translations.PluralTranslations do
  @moduledoc """
  Plural translations Kanta subcontext
  """

  alias Kanta.Repo
  alias Kanta.Translations.PluralTranslation

  alias Kanta.Translations.PluralTranslations.Finders.{
    GetPluralTranslation,
    ListPluralTranslations
  }

  def list_plural_translations(params \\ []) do
    ListPluralTranslations.find(params)
  end

  def get_plural_translation(params \\ []) do
    GetPluralTranslation.find(params)
  end

  def create_plural_translation(attrs) do
    attrs
    |> then(&PluralTranslation.changeset(%PluralTranslation{}, &1))
    |> Repo.get_repo().insert()
  end

  def update_plural_translation(translation, attrs) do
    PluralTranslation.changeset(translation, attrs)
    |> Repo.get_repo().update()
  end
end
