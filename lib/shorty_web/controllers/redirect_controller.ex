defmodule ShortyWeb.RedirectController do
  @moduledoc """
  This controller manages redirects to the URLs referenced by various short slugs.
  """

  use ShortyWeb, :controller

  require Logger

  alias Shorty.{
    Link,
    Repo
  }

  alias ShortyWeb.ErrorView

  def show(conn, %{"slug" => slug}) do
    case Repo.get(Link, slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.html")

      link ->
        Logger.info("Redirecting #{link.slug} to #{link.url}")
        redirect(conn, external: link.url)
    end
  end
end
