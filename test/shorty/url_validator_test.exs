defmodule Shorty.URLValidatorTest do
  use ExUnit.Case, async: true

  alias Shorty.URLValidator

  describe "validate/1 scheme checks" do
    test "require scheme to be http or https" do
      assert {:ok, _} = URLValidator.validate("http://hostname.com")
      assert {:ok, _} = URLValidator.validate("https://hostname.com")

      assert {:error, :invalid_scheme} = URLValidator.validate("httpss://hostname.com")
      assert {:error, :invalid_scheme} = URLValidator.validate("ftp://hostname.com")
    end

    test "assume https if no scheme is specified" do
      assert {:ok, "https://hostname.com"} = URLValidator.validate("hostname.com")
    end

    test "normalize scheme to lowercase" do
      assert {:ok, "http://hostname.com"} = URLValidator.validate("HTTP://hostname.com")
    end
  end

  describe "validate/1 host checks" do
    test "require a qualified domain name" do
      assert {:ok, _} = URLValidator.validate("https://hostname.com")

      assert {:error, :invalid_domain} = URLValidator.validate("hostname")
      assert {:error, :invalid_domain} = URLValidator.validate("hostname.")
      assert {:error, :invalid_domain} = URLValidator.validate("hostname.?")
      assert {:error, :invalid_domain} = URLValidator.validate("hostname.#")
    end

    test "normalize hostname to lowercase" do
      assert {:ok, "http://hostname.com"} = URLValidator.validate("http://HoStNamE.cOm")
    end
  end
end
