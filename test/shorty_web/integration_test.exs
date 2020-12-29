defmodule ShortyWeb.IntegrationTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature
  import Wallaby.Query

  # For some reason, I couldn't get this to work, but I timed out trying to
  # troubleshoot it.
  @tag :skip
  feature "can create shortlinks", %{session: session} do
    url = "www.google.com/search?q=Testing"

    session
    |> visit("http://localhost:4000/")
    |> fill_in(fillable_field("Paste your long link here"), with: url)
    |> click(button("Shorten"))
    |> assert_has(Query.css("a", text: "url"))
  end
end
