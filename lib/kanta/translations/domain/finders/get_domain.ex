defmodule Kanta.Translations.Domains.Finders.GetDomain do
  @moduledoc """
  Query module aka Finder responsible for finding gettext domain
  """

  use Kanta.Query,
    module: Kanta.Translations.Domain,
    binding: :domain

  alias Kanta.Translations.Domain

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %Domain{} = domain} -> {:ok, domain}
      {:error, _, :not_found} -> {:error, :domain, :not_found}
    end
  end

  defp find_in_database(params) do
    base()
    |> filter_query(params[:filter])
    |> preload_resources(params[:preloads] || [])
    |> one()
    |> case do
      %Domain{} = domain -> {:ok, domain}
      _ -> {:error, :domain, :not_found}
    end
  end
end
