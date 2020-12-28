defmodule ShortyWeb.ShortenerLive do
  @moduledoc """
  This Live View powers the URL-shortener component where users can type a long
  URL and click the button to create a shortened link to that URL.
  """

  use ShortyWeb, :live_view

  alias Shorty.URLValidator

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(url: "")
      |> assign_validation_message("")

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"url" => url}, socket) do
    {:noreply, assign_validation_message(socket, URLValidator.validate(url))}
  end

  @impl true
  def handle_event("shorten", %{"url" => url}, socket) do
    case validation = URLValidator.validate(url) do
      {:ok, normalized_url} ->
        Logger.info("Shortened url: #{normalized_url}")

      {:error, reason} ->
        Logger.info("Failed to shorten url: #{url} reason: #{reason}")
    end

    {:noreply, assign_validation_message(socket, validation)}
  end

  defp assign_validation_message(socket, message) when is_binary(message) do
    assign(socket, validation_message: message)
  end

  defp assign_validation_message(socket, {:ok, _}) do
    assign(socket, validation_message: "")
  end

  defp assign_validation_message(socket, {:error, reason}) do
    assign(socket, validation_message: validation_message(reason))
  end

  defp validation_message(:invalid_scheme), do: "Your URL must use http or https"
  defp validation_message(:invalid_domain), do: "Your URL must use a qualified domain"
  defp validation_message(_), do: "Your URL is invalid"
end
