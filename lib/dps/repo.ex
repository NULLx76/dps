defmodule Dps.Repo do
  use Ecto.Repo,
    otp_app: :dps,
    adapter: Ecto.Adapters.Postgres
end
