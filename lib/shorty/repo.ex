defmodule Shorty.Repo do
  use Ecto.Repo,
    otp_app: :shorty,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    runtime_opts =
      :repo
      |> Shorty.Config.fetch()
      |> Enum.into([])

    {:ok, Keyword.merge(config, runtime_opts)}
  end
end
