defmodule Shorty.LinkTest do
  use Shorty.DataCase, async: true

  alias Ecto.Changeset

  alias Shorty.{
    Link,
    Repo
  }

  @valid_params %{slug: "abc1234", url: "https://www.google.com/search?q=something"}

  describe "new/1" do
    test "returns a Link struct with valid parameters" do
      assert %Changeset{valid?: true} = Link.new(@valid_params)
    end

    test "requires url field" do
      assert %Changeset{valid?: false} = Link.new(Map.delete(@valid_params, :url))
    end

    test "ensures URLs are not overly long" do
      long_url = "https://domain.com/" <> String.duplicate("a", 4096)
      assert %Changeset{valid?: false} = changeset = Link.new(%{url: long_url})
      assert %{url: ["should be at most 4096 character(s)"]} = errors_on(changeset)
    end

    test "ensures slugs are not overly long" do
      link_with_long_slug = Map.put(@valid_params, :slug, String.duplicate("a", 10))
      assert %Changeset{valid?: false} = changeset = Link.new(link_with_long_slug)
      assert %{slug: ["should be at most 8 character(s)"]} = errors_on(changeset)
    end

    test "generates a slug if one is not given" do
      missing_slug = Link.new(Map.delete(@valid_params, :slug))
      assert %Changeset{valid?: true, changes: %{slug: slug}} = missing_slug
      assert is_binary(slug)
      assert String.length(slug) == 7
    end

    test "ensures there are no duplicate slugs in the DB" do
      assert {:ok, %Link{}} = Repo.insert(Link.new(@valid_params))
      assert {:error, changeset} = Repo.insert(Link.new(@valid_params))
      assert %{slug: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
