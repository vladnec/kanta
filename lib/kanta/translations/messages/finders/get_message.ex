defmodule Kanta.Translations.Messages.Finders.GetMessage do
  @moduledoc """
  Query module aka Finder responsible for finding gettext message
  """

  use Kanta.Query,
    module: Kanta.Translations.Message,
    binding: :message

  alias Kanta.Repo
  alias Kanta.Translations.Message

  def find(params \\ []) do
    case find_in_database(params) do
      {:ok, %Message{} = message} -> {:ok, message}
      {:error, _, :not_found} -> {:error, :message, :not_found}
    end
  end

  defp find_in_database(params, opts \\ []) do
    base()
    |> filter_query(params[:filter])
    |> search_query(params[:search])
    |> preload_resources(params[:preloads] || [])
    |> limit(1)
    |> one(opts)
    |> case do
      %Message{} = message -> {:ok, message}
      _ -> {:error, :message, :not_found}
    end
    |> database_fallback_public_prefix(params, opts, Repo.get_repo().__adapter__())
  end

  defp database_fallback_public_prefix(
         {:error, :message, :not_found} = result,
         params,
         repo_opts,
         Ecto.Adapters.Postgres
       ) do
    if public_prefix?(repo_opts) do
      result
    else
      opts = Keyword.put(repo_opts, :prefix, "public")
      find_in_database(params, opts)
    end
  end

  defp database_fallback_public_prefix(result, _, _, _), do: result

  defp public_prefix?(repo_opts) do
    config_prefix = Repo.get_repo().default_options(:all) |> Keyword.get(:prefix, :unset)
    opts_prefix = Keyword.get(repo_opts, :prefix, :unset)
    config_prefix in [nil, "public"] or opts_prefix in [nil, "public"]
  end
end
