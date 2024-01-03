defmodule SyncitWeb.RoomController do
  use SyncitWeb, :controller

  def index(conn, _params) do
    render(conn, :room, layout: false)
  end
end
