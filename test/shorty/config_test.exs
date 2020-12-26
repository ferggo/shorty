defmodule Shorty.ConfigTest do
  use ExUnit.Case, async: true

  alias Shorty.Config

  describe "validate_endpoint_url/1" do
    test "requires scheme to be http or https" do
      assert Config.validate_endpoint_url("http://localhost")
      assert Config.validate_endpoint_url("https://localhost")

      assert_raise RuntimeError, ~r/http or https/, fn ->
        Config.validate_endpoint_url("ssh://localhost:22/")
      end

      assert_raise RuntimeError, ~r/http or https/, fn ->
        Config.validate_endpoint_url("hostname:443/path")
      end

      assert_raise RuntimeError, ~r/http or https/, fn ->
        Config.validate_endpoint_url("httpss://hostname:443/")
      end
    end

    test "requires host to be specified" do
      assert Config.validate_endpoint_url("http://my_host/path?q=foo")

      assert_raise RuntimeError, ~r/must specify a host/, fn ->
        Config.validate_endpoint_url("http:///path?q=foo")
      end
    end

    test "Assumes implied http and https ports if not specified" do
      assert Config.validate_endpoint_url("http://localhost")
      assert Config.validate_endpoint_url("https://localhost")
      assert Config.validate_endpoint_url("http://localhost:1234")
    end
  end

  describe "validate_db_url/1" do
    test "accepts a valid Postgres connection string" do
      assert Config.validate_db_url("postgresql://username:password@localhost:5432/db")
    end

    test "requires scheme to be postgresql" do
      assert_raise RuntimeError, ~r/scheme must be postgresql/, fn ->
        Config.validate_db_url("pg://username:password@localhost:5432/db")
      end
    end

    test "requires host to be specified" do
      assert_raise RuntimeError, ~r/must specify a host/, fn ->
        Config.validate_db_url("postgresql://username:password@/db")
      end
    end

    test "requires database to be specified" do
      assert_raise RuntimeError, ~r/must specify a database/, fn ->
        Config.validate_db_url("postgresql://username:password@localhost/")
      end
    end
  end
end
