defmodule Kanta.Translations.SingularTranslations do
  @moduledoc """
  Singular translations Kanta subcontext
  """

  alias Kanta.Translations.SingularTranslations.Finders.GetSingularTranslation

  alias Kanta.Repo
  alias Kanta.Translations.SingularTranslation

  def get_singular_translation(params \\ []) do
    GetSingularTranslation.find(params)
  end

  def create_singular_translation(attrs) do
    attrs
    |> then(&SingularTranslation.changeset(%SingularTranslation{}, &1))
    |> Repo.get_repo().insert()
  end

  def update_singular_translation(translation, attrs) do
    SingularTranslation.changeset(translation, attrs)
    |> Repo.get_repo().update()
  end
end
