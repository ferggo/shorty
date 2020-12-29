defmodule ShortyWeb.RedirectController do
  @moduledoc """
  This controller manages redirects to the URLs referenced by various short slugs.
  """

  use ShortyWeb, :controller

  alias ShortyWeb.ErrorView

  def show(conn, %{"slug" => _slug}) do
    conn
    |> put_view(ErrorView)
    |> put_status(:not_found)
    |> render("404.html")
  end
end
