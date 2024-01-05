defmodule SyncitWeb.LobbyPlayerViewersLive do
  use SyncitWeb, :live_view
  alias Syncit.Lobby.PlayerAgent

  @topic "lobby:viewers"

  def render(assigns) do
    ~H"""
    <span class="flex text-[0.8125rem] px-2 font-medium leading-6">
            <svg viewBox="0 0 24 24" aria-hidden="true" class="h-6 w-6">
                <path fill-rule="evenodd" clip-rule="evenodd" fill="#FD4F00"
                      d="M.664 10.59a1.651 1.651 0 010-1.186A10.004 10.004 0 0110 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0110 17c-4.257 0-7.893-2.66-9.336-6.41zM14 10a4 4 0 11-8 0 4 4 0 018 0z"
                />
            </svg>
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
