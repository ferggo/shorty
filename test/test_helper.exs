ExUnit.start(capture_log: true)
Ecto.Adapters.SQL.Sandbox.mode(Shorty.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:wallaby)
