defmodule SyncitWeb.RoomChannel do
  use SyncitWeb, :channel
  alias Syncit.Lobby.ViewersCounter

  @topic "viewers"
  @channel "room:lobby"

  @impl true
  def join(@channel, _payload, socket) do
    ViewersCounter.increment()
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "join", %{})
    {:ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    ViewersCounter.decrement()
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "left", %{})
    {:ok, socket}
  end

  @impl true
  def handle_in(message, payload, socket) do
    broadcast(socket, message, payload)
    {:noreply, socket}
  end
end
