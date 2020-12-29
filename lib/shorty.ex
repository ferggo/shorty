defmodule Shorty do
  @moduledoc """
  This is the API of the Shorty core domain.
  """

  require Logger

  alias Ecto.Changeset

  alias Shorty.{
    Link,
    Repo,
    URLValidator
  }

  def create_link(url, slug \\ nil) do
    with {:ok, normalized_url} <- URLValidator.validate(url),
         %Changeset{valid?: true} = changeset <- Link.new(%{url: normalized_url, slug: slug}),
         {:ok, link} <- associate_slug(changeset) do
      Logger.info("Created link from slug: #{link.slug} to url: #{link.url}")
      {:ok, link}
    else
      %Changeset{errors: errors} ->
        Logger.info("Failed to create link for url: #{url} reason: #{inspect(errors)}")
        {:error, :invalid}

      {:error, reason} ->
        Logger.info("Failed to create link for url: #{url} reason: #{reason}")
        {:error, reason}
    end
  end

  # This retries indefinitely to deal with the unlikely case of a slug
  # collision at the database level.
  defp associate_slug(changeset) do
    case Repo.insert(changeset) do
      {:ok, link} ->
        {:ok, link}

      {:error, %Changeset{errors: errors} = changeset} ->
        if slug_already_taken?(errors) do
          Logger.error("Database conflict. Retrying.")
          # Try again, generating a new slug
          url = Changeset.get_change(changeset, :url)
          associate_slug(Link.new(%{url: url}))
        else
          {:error, changeset}
        end
    end
  end

  defp slug_already_taken?(errors) do
    Enum.any?(errors, fn e -> match?({:slug, {"has already been taken", _meta}}, e) end)
  end
end
