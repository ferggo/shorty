# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shorty,
  ecto_repos: [Shorty.Repo]

# Configures the endpoint
config :shorty, ShortyWeb.Endpoint,
  transport_options: [socket_opts: [:inet6]],
  render_errors: [view: ShortyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Shorty.PubSub,
  live_view: [signing_salt: "5kfiY4sk"]

# Configures Elixir's Logger
config :logger,
  level: :info

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
