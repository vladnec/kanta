defmodule Kanta.Translations.Locale.Finders.GetLocale do
  @moduledoc """
  Query module aka Finder responsible for finding locale
  """

  use Kanta.Query,
    module: Kanta.Translations.Locale,
    binding: :locale

  alias Kanta.Translations.Locale

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %Locale{} = locale} -> {:ok, locale}
      {:error, _, :not_found} -> {:error, :locale, :not_found}
    end
  end

  defp find_in_database(params) do
    base()
    |> filter_query(params[:filter])
    |> preload_resources(params[:preloads] || [])
    |> one()
    |> case do
      %Locale{} = locale -> {:ok, locale}
      _ -> {:error, :locale, :not_found}
    end
  end
end
