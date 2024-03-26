defmodule Kanta.Translations.SingularTranslations.Finders.GetSingularTranslation do
  @moduledoc """
  Query module aka Finder responsible for finding singular translations
  """

  use Kanta.Query,
    module: Kanta.Translations.SingularTranslation,
    binding: :singular_translation

  alias Kanta.Translations.SingularTranslation

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %SingularTranslation{} = singular_translation} -> {:ok, singular_translation}
      {:error, _, :not_found} -> {:error, :singular_translation, :not_found}
    end
  end

  defp find_in_database(params) do
    base()
    |> filter_query(params[:filter])
    |> search_query(params[:search])
    |> preload_resources(params[:preloads] || [])
    |> one()
    |> case do
      %SingularTranslation{} = singular_translation -> {:ok, singular_translation}
      _ -> {:error, :singular_translation, :not_found}
    end
  end
end
