defmodule SyncitWeb.LobbyPlayerViewersLive do
  use SyncitWeb, :live_view
  alias Syncit.Lobby.PlayerAgent

  @topic "lobby:viewers"

  def render(assigns) do
    ~H"""
    <span class="flex text-[0.9125rem] indent-px px-1 font-medium leading-6">
      <img src={~p"/images/viewers.svg"} width="20"/>
      <%= @viewers_count %>
    </span>
    """
  end

  def mount(_params, _session, socket) do
    SyncitWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, viewers_count: PlayerAgent.get_viewers_count()), layout: false}
  end

  def handle_info(%{topic: @topic, event: "join"}, socket) do
    {:noreply, assign(socket, viewers_count: socket.assigns.viewers_count + 1)}
  end

  def handle_info(%{topic: @topic, event: "left"}, socket) do
    {:noreply, assign(socket, viewers_count: socket.assigns.viewers_count - 1)}
  end
end
