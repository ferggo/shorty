use Mix.Config

# Configure your database
config :shorty, Shorty.Repo, pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shorty, ShortyWeb.Endpoint, server: false
