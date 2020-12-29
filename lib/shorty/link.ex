defmodule Shorty.Link do
  @moduledoc """
  This schema represents a short link, which maps from a shot slug to a long URL.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Shorty.Link

  @required_fields [:slug, :url]
  @all_fields @required_fields

  @primary_key false
  schema "links" do
    field :slug, :string, primary_key: true
    field :url, :string

    timestamps()
  end

  def new(params \\ %{}) do
    %Link{}
    |> cast(params, @all_fields)
    |> maybe_generate_slug()
    |> validate_required(@required_fields)
    |> validate_length(:slug, max: 8)
    |> validate_length(:url, max: 4096)
    |> unique_constraint(:slug, name: "links_pkey")
  end

  defp maybe_generate_slug(changeset) do
    case get_change(changeset, :slug) do
      nil -> put_change(changeset, :slug, encode_random_bytes(4))
      _slug -> changeset
    end
  end

  defp encode_random_bytes(byte_count) do
    byte_count
    |> :crypto.strong_rand_bytes()
    |> Base.encode32(case: :lower, padding: false)
  end
end
