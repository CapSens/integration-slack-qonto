defmodule CapsensQonto.Repo do
  use Ecto.Repo,
    otp_app: :capsens_qonto,
    adapter: Ecto.Adapters.Postgres
end
