defmodule Kanta.Translations.PluralTranslations.Finders.GetPluralTranslation do
  @moduledoc """
  Query module aka Finder responsible for finding plural translation
  """

  use Kanta.Query,
    module: Kanta.Translations.PluralTranslation,
    binding: :plural_translation

  alias Kanta.Translations.PluralTranslation

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %PluralTranslation{} = plural_translation} -> {:ok, plural_translation}
      {:error, _, :not_found} -> {:error, :plural_translation, :not_found}
    end
  end

  defp find_in_database(params) do
    base()
    |> filter_query(params[:filter])
    |> search_query(params[:search])
    |> preload_resources(params[:preloads] || [])
    |> one()
    |> case do
      %PluralTranslation{} = plural_translation -> {:ok, plural_translation}
      _ -> {:error, :plural_translation, :not_found}
    end
  end
end
