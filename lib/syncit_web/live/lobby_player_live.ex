defmodule SyncitWeb.LobbyPlayerLive do
  use SyncitWeb, :live_view
  alias Syncit.Lobby.PlayerAgent

  @topic "lobby:player"

  def render(assigns) do
    ~H"""
    <div class="px-4 py-10 xl:px-28 flex flex-col h-full max-h-screen w-screen max-w-screen-2xl">
        <div id="player" video-id={@video_id} phx-hook="Player" phx-window-key="Enter"></div>
        <%= live_render(@socket, SyncitWeb.LobbyPlayerViewersLive, id: "player-viewers") %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    SyncitWeb.Endpoint.subscribe(@topic)

    {:ok, assign(socket, video_id: PlayerAgent.get_video_id()), layout: false}
  end

  def handle_info(%{topic: @topic, event: "update_video", payload: payload}, socket) do
    video_id = payload[:video_id]
    PlayerAgent.update_video_id(video_id)

    {:noreply, assign(socket, video_id: video_id)}
  end
end
