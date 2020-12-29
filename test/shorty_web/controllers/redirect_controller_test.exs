defmodule ShortyWeb.RedirectControllerTest do
  use ShortyWeb.ConnCase, async: true

  alias Shorty.{
    Link,
    Repo
  }

  test "returns a 404 for non-existent slugs", %{conn: conn} do
    conn = get(conn, "/abc123")
    assert conn.status == 404
    assert conn.resp_body =~ ~r/This shorty doesn't exist/
  end

  test "redirects for slugs that exist", %{conn: conn} do
    url = "https://www.google.com/search?q=testing"
    {:ok, link} = Repo.insert(Link.new(%{url: url}))

    conn = get(conn, "/#{link.slug}")
    assert conn.status == 302
    assert get_resp_header(conn, "location") == [url]
  end
end
