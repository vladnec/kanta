defmodule Kanta.Translations.Contexts.Finders.GetContext do
  @moduledoc """
  Query module aka Finder responsible for finding gettext context
  """

  use Kanta.Query,
    module: Kanta.Translations.Context,
    binding: :context

  alias Kanta.Translations.Context

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %Context{} = context} -> {:ok, context}
      {:error, _, :not_found} -> {:error, :context, :not_found}
    end
  end

  defp find_in_database(params) do
    base()
    |> filter_query(params[:filter])
    |> preload_resources(params[:preloads] || [])
    |> one()
    |> case do
      %Context{} = context -> {:ok, context}
      _ -> {:error, :context, :not_found}
    end
  end
end
