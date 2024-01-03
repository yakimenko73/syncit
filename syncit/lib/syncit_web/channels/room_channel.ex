defmodule SyncitWeb.RoomChannel do
  use SyncitWeb, :channel

  @impl true
  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in(message, payload, socket) do
    broadcast(socket, message, payload)
    {:noreply, socket}
  end
end
