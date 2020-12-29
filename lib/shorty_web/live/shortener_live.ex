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
      |> assign(history: [])
      |> assign_validation_message("")

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"url" => url}, socket) do
    {:noreply, assign_validation_message(socket, URLValidator.validate(url))}
  end

  @impl true
  def handle_event("shorten", %{"url" => url}, socket) do
    with {:ok, normalized_url} <- URLValidator.validate(url),
         {:ok, link} <- Shorty.create_link(normalized_url) do
      Logger.info("Shortened slug: #{link.slug} to url: #{link.url}")
      {:noreply, assign_success(socket, link)}
    else
      {:error, reason} = validation ->
        Logger.info("Failed to shorten url: #{url} reason: #{reason}")
        {:noreply, assign_validation_message(socket, validation)}
    end
  end

  defp assign_success(socket, link) do
    history_item = %{
      shorty: "#{ShortyWeb.Endpoint.url()}/#{link.slug}",
      url: link.url
    }

    socket
    |> assign(:history, [history_item | socket.assigns[:history]])
    |> assign_validation_message("")
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
  defp validation_message(:invalid), do: "Your URL is invalid"
  defp validation_message(_), do: "Oops... Please try again later"
end
