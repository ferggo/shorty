defmodule Shorty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Shorty.Config.load!()

    children = [
      Shorty.Repo,
      ShortyWeb.Telemetry,
      {Phoenix.PubSub, name: Shorty.PubSub},
      ShortyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shorty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShortyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
