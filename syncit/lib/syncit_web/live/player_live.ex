defmodule SyncitWeb.PlayerLive do
  use SyncitWeb, :live_view

  @topic "lobby:player"
  @default_video_id "DwKQqAgKuKY"

  def render(assigns) do
    ~H"""
    <div id="player" video-id={@video_id} phx-hook="Player" phx-window-key="Enter"></div>
    """
  end

  def mount(_params, _session, socket) do
    SyncitWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, video_id: @default_video_id), layout: false}
  end

  def handle_info(%{topic: @topic, event: "update_video", payload: payload}, socket) do
    {:noreply, assign(socket, video_id: payload[:video_id])}
  end
end
