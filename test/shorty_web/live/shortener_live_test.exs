defmodule ShortyWeb.ShortenerLiveTest do
  use ShortyWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Paste your long link here"
    assert render(page_live) =~ "Paste your long link here"
  end
end
