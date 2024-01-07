defmodule Syncit.Repo do
  use Ecto.Repo,
    otp_app: :syncit,
    adapter: Ecto.Adapters.Postgres
end
