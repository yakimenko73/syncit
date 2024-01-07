defmodule SyncitWeb.LobbyController do
  use SyncitWeb, :controller

  def index(conn, _params) do
    render(conn, :lobby, layout: false)
  end
end
