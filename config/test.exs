use Mix.Config

# Configure your database
config :shorty, Shorty.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :shorty, ShortyWeb.Endpoint, server: true

config :wallaby, otp_app: :shorty
