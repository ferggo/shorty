defmodule ShortyTest do
  use Shorty.DataCase, async: true

  alias Shorty.Link

  describe "create_link/1" do
    test "performs scheme validations" do
      assert {:error, :invalid_scheme} = Shorty.create_link("ftp://hostname.com")
    end

    test "performs domain validations" do
      assert {:error, :invalid_domain} = Shorty.create_link("https://hostname.")
    end

    test "normalizes scheme and hostname" do
      url = "hTtP://HoStNamE.cOm/SomePath?Foo=Bar#Fragment"
      expected = "http://hostname.com/SomePath?Foo=Bar#Fragment"
      assert {:ok, %Link{url: ^expected}} = Shorty.create_link(url)
    end

    test "retries on slug collision" do
      {:ok, link} =
        %{url: "https://example.com/", slug: "abc1234"}
        |> Link.new()
        |> Repo.insert()

      assert {:ok, %Link{slug: slug}} = Shorty.create_link(link.url, link.slug)
      assert is_binary(slug)
      refute slug == "abc1234"
    end
  end
end
