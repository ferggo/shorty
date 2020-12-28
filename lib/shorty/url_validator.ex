defmodule Shorty.URLValidator do
  @moduledoc """
  This module defines the validation rules for URLs to be shortened.
  """

  def validate(""), do: {:ok, ""}

  def validate(original_url) do
    url = normalize(original_url)
    %URI{scheme: scheme, host: host} = URI.parse(url)

    cond do
      scheme != "http" && scheme != "https" ->
        {:error, :invalid_scheme}

      !matches?(~r/\w\.\w/, host) ->
        {:error, :invalid_domain}

      true ->
        {:ok, url}
    end
  end

  defp normalize(url) do
    url
    |> URI.parse()
    |> normalize_scheme(url)
    |> normalize_host()
    |> URI.to_string()
  end

  defp normalize_scheme(%URI{scheme: nil}, original_url),
    do: URI.parse("https://" <> original_url)

  defp normalize_scheme(%URI{scheme: scheme} = uri, _original_url) when is_binary(scheme),
    do: %URI{uri | scheme: String.downcase(scheme)}

  defp normalize_host(%URI{host: host} = uri) when is_binary(host),
    do: %URI{uri | host: String.downcase(host)}

  defp normalize_host(uri), do: uri

  defp matches?(regex, string) when is_binary(string),
    do: Regex.match?(regex, string)

  defp matches?(_regex, _string), do: false
end
