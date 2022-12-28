defmodule Friends.Repo do
  use Ecto.Repo,
    otp_app: :friends,
    # adapter: Ecto.Adapters.Postgres
    adapter: Ecto.Adapters.MyXQL
end
