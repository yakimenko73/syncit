defmodule SyncitWeb.LobbyChannel do
  use SyncitWeb, :channel
  alias Syncit.Lobby.PlayerAgent

  @topic "lobby:viewers"
  @channel "lobby"

  @impl true
  def join(@channel, _payload, socket) do
    PlayerAgent.increment_viewers_count()
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "join", %{})
    {:ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    PlayerAgent.decrement_viewers_count()
    SyncitWeb.Endpoint.broadcast_from(self(), @topic, "left", %{})
    {:ok, socket}
  end

  @impl true
  def handle_in(message, payload, socket) do
    broadcast(socket, message, payload)
    {:noreply, socket}
  end
end
