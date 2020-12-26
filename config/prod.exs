use Mix.Config

config :shorty, ShortyWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true
