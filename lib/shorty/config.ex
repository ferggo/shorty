defmodule Shorty.Config do
  @moduledoc """
  This module is used to manage and validate configuration parameters. Ideally,
  all of the available options would be here for easy cross-reference and
  visibility for team members.
  """

  use Vapor.Planner

  dotenv()

  config :endpoint,
         env([
           {:url, "ENDPOINT_URL", map: &validate_endpoint_url/1},
           {:listener_port, "LISTENER_PORT", default: 4000, map: &String.to_integer/1},
           {:secret_key_base, "SECRET_KEY_BASE"}
         ])

  config :repo,
         env([
           {:url, "DATABASE_URL", map: &validate_db_url/1},
           {:pool_size, "DATABASE_POOL_SIZE", default: 20, map: &String.to_integer/1}
         ])

  @doc "Call this on Application start or when you want to reload configuration"
  def load! do
    config = Vapor.load!(__MODULE__)
    :ok = :persistent_term.put(__MODULE__, config)
    config
  end

  @doc """
  Fetch a subset of the configuration either via atom key or list of atom keys.
  With an atom key, the group of options will be returned.
  With a list, only that particular option will be returned.

  If the configuration has not been loaded yet, it will be loaded prior to fetching.
  """
  def fetch(key) when is_atom(key), do: fetch([key])

  def fetch(keys) when is_list(keys) do
    config = :persistent_term.get(__MODULE__, nil) || load!()
    get_in(config, keys)
  end

  # These validators should really be private, but they're public so they can be unit-tested.
  @doc false
  def validate_endpoint_url(url) do
    %URI{scheme: scheme, host: host} = URI.parse(url)

    cond do
      scheme != "http" && scheme != "https" ->
        raise "ENDPOINT_URL must specify a scheme of http or https"

      !is_binary(host) || String.length(host) == 0 ->
        raise "ENDPOINT_URL must specify a host"

      true ->
        url
    end
  end

  @doc false
  def validate_db_url(url) do
    %URI{scheme: scheme, host: host, path: path} = URI.parse(url)

    cond do
      scheme != "postgresql" ->
        raise "DATABASE_URL scheme must be postgresql"

      !is_binary(host) || String.length(host) == 0 ->
        raise "DATABASE_URL must specify a host"

      !is_binary(path) || String.length(path) <= 1 ->
        raise "DATABASE_URL must specify a database"

      true ->
        url
    end
  end
end
